Return-Path: <linux-kernel-owner+w=401wt.eu-S1765972AbYBZVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765972AbYBZVps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765781AbYBZVpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:45:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765736AbYBZVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:45:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25-current-git hangs on boot
Date: Tue, 26 Feb 2008 22:44:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Soeren Sonnenburg" <kernel@nn7.de>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <1203789325.4063.9.camel@localhost> <200802241218.04617.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEE9AA266@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE9AA266@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262244.11933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Pallipadi, Venkatesh wrote:
> 
> >-----Original Message-----
> >From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> >Sent: Sunday, February 24, 2008 3:18 AM
> >To: Soeren Sonnenburg
> >Cc: Oliver Pinter; Linux Kernel; Pallipadi, Venkatesh
> >Subject: Re: 2.6.25-current-git hangs on boot
> >
> >On Sunday, 24 of February 2008, Soeren Sonnenburg wrote:
> >> On Sat, 2008-02-23 at 20:00 +0100, Oliver Pinter wrote:
> >> > the pci=nommconf kernel parameter helped it?
> >> 
> >> yes indeed, this switch reliably helps to over come the hang at *this
> >> stage* (I tried booting with booth the switch and w/o).
> >> 
> >> however with 50% chance I still see a hang directly after
> >> 
> >> cpuidle: using governor ladder
> >
> >Do you have CONFIG_CPU_IDLE set?  If you have, please try to 
> >unset it and
> >retest.
> >
> 
> Rafael,
> 
> I am looking at the CPU_IDLE part of this regression. Just want to note
> that there is another regression with needing pci=nommconf in current
> git which was not required in .24. I am not sure whether you are already
> tracking that as a different issue.

I've noticed the thread, but I haven't created a Bugzilla entry for it yet.

Thanks for the information anyway. :-)

Rafael
