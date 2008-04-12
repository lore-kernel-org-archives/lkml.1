Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYDLH14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYDLH14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 03:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYDLH1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 03:27:47 -0400
Received: from nn7.de ([85.214.94.156]:58364 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbYDLH1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:27:46 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080411210400.GA1533@elf.ucw.cz>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost>
	 <20080411210400.GA1533@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 12 Apr 2008 09:27:42 +0200
Message-Id: <1207985262.4372.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 23:04 +0200, Pavel Machek wrote:
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

I did on 2.6.24

strace -ff s2ram >s2ram24.trace 2>&1

and .25

﻿strace -ff s2ram >s2ram25.trace 2>&1

with the .24 bringing the display back and .25 not. Files are here

http://nn7.de/debugging/s2ram24.trace.bz2
﻿http://nn7.de/debugging/s2ram25.trace.bz2

I have no idea how to 'disable randomization' and also not which
debugging options I should have set ... tell me what things/options you
need to be en/disabled and I redo the experiment.

Soeren
