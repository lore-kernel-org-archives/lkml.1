Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYDKVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYDKVD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbYDKVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:03:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46393 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbYDKVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:03:21 -0400
Date: Fri, 11 Apr 2008 23:04:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc6 regression - hang on resume
Message-ID: <20080411210400.GA1533@elf.ucw.cz>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207290689.4511.1.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-04 08:31:29, Soeren Sonnenburg wrote:
> On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > Subject		: 2.6.25-rc6 regression - hang on resume
> > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > Date		: 2008-03-25 04:44 (10 days old)
> 
> Yes. The machine resumes and display stays black using s2ram -f -p
> (blindly typing reboot etc on keyboard does what is expected). However
> display comes back on 2.6.24.

Could you get us any debugging output from s2ram? Or maybe even strace
it in both working and broken case, and comparing them? (You may want
to disable randomization so that results are comparable).

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
