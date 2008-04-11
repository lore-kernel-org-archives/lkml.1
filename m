Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbYDKVIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbYDKVIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761064AbYDKVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:07:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760553AbYDKVH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:07:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-rc6 regression - hang on resume
Date: Fri, 11 Apr 2008 23:08:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <1207290689.4511.1.camel@localhost> <20080411210400.GA1533@elf.ucw.cz>
In-Reply-To: <20080411210400.GA1533@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804112308.19994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of April 2008, Pavel Machek wrote:
> On Fri 2008-04-04 08:31:29, Soeren Sonnenburg wrote:
> > On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> > > The following report is on the current list of known regressions
> > > from 2.6.24.  Please verify if the issue is still present in the
> > > mainline.
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > > Subject		: 2.6.25-rc6 regression - hang on resume
> > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > Date		: 2008-03-25 04:44 (10 days old)
> > 
> > Yes. The machine resumes and display stays black using s2ram -f -p
> > (blindly typing reboot etc on keyboard does what is expected). However
> > display comes back on 2.6.24.
> 
> Could you get us any debugging output from s2ram? Or maybe even strace
> it in both working and broken case, and comparing them? (You may want
> to disable randomization so that results are comparable).

Please also test the kernel with the patch from
http://bugzilla.kernel.org/attachment.cgi?id=15736&action=view
applied.

Thanks,
Rafael
