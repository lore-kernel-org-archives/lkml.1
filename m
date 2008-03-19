Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYCSThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYCSThq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYCST27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:28:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbYCST25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:28:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Wed, 19 Mar 2008 20:28:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0803191057270.4958-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803191057270.4958-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192028.27383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Alan Stern wrote:
> On Tue, 18 Mar 2008, Eric W. Biederman wrote:
> 
> > Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > > Could it be connected with the way the boot kernel hands control over
> > > to the image kernel?  Presumably ACPI isn't prepared to deal with that
> > > sort of thing during a boot from S5.  It would have to be fooled into
> > > thinking the two kernels were one and the same.
> > 
> > It should be easy to test if it is a hand over problem, by turning off
> > the laptop by placing it in S5 (shutdown -h now) and then booting same
> > kernel again.
> 
> ?  Doesn't this happen every time Rafael turns the computer off and 
> then turns it back on?
> 
> Do you mean that Rafael should do an S5-type hibernate, but then reboot 
> in such a way that the image isn't loaded and resumed?

That will work.

The problem happens when the control goes back to the hibernated kernel.

I _think_ it has to do with the suspend(PRETHAW) thing we do before that,
but frankly I'm not too inclined to verify it as the problem is generally
dangerous to the hardware (not working thermal management on a notebook is
never fun).

Thanks,
Rafael
