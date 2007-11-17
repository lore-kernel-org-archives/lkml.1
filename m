Return-Path: <linux-kernel-owner+w=401wt.eu-S1763799AbXKQGp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763799AbXKQGp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXKQGpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:45:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:51256 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXKQGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rEp7Mvwxm4zKRRiL/FZTYEQ7cIb7CWTQUddresOPj3FSyxV+fcs5o/m6X/As6O0G+ED6idMT9TTBu3Svi758ZArOOG3zFZra/l2vN9g3fgt3gkj9dOCRn8cNGhSw1d0d7fJpTdBiYgBVUQ+pJrZjvTEZ3Tk3WgyIbDZ7DHhExqU=
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
From: Dane Mutters <dmutters@gmail.com>
To: Martin Olsson <mnemo@minimum.se>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ubuntu Devel Discuss <ubuntu-devel-discuss@lists.ubuntu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <473E9290.3040006@minimum.se>
References: <473E815F.30900@minimum.se>
	 <20071116213137.6efe3f9e@the-village.bc.nu>  <473E9290.3040006@minimum.se>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 22:45:42 -0800
Message-Id: <1195281942.15929.5.camel@Orchestrator>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I thought you might find this helpful.  (I brought this issue up with
the Slackware folks once, and they told me basically this.)

http://wiki.craz1.homelinux.com/index.php/Linux:Security:Forkbomb

I was also told that the ability to spawn such rampant forks/processes
is controlled by default in Debian.  Is this the case?

Here is an LQ thread where I brought it up:

http://www.linuxquestions.org/questions/linux-security-4/how-can-i-prevent-forkbombs-338560/

I would like to see something done about this, with Ubuntu as popular as
it is, even as a server in some cases.  Is there a way that in the
future, one could simply download a package or click a box or something
and have a limit set, like the links suggest?  That would make things
just "that much" more convenient for system administrators (and might
help them/us to remember to set these limits, too...).

Thanks.

-Dane


On Fri, 2007-11-16 at 23:04 -0800, Martin Olsson wrote:
> Sorry about that, I checked the "has security impact" checkbox and that 
> marked it as private by default. This is a very well known problem 
> though so keeping secret certainly does not make sense. I have manually 
> removed the "private" flag now.
> 
> The content of the bug report was as follows:
> ---------------------------------------------
> 
> Repro steps:
> 
> 1. Install gutsy gibbon (or probably any ubuntu)
> 2. Start a gnome terminal
> 3. Run this command:
> 
>     :(){ :|:& };:
> 
> 4. Ubuntu starts to work furiously, after less than a second terminal 
> gets flooded with "low resources" message, and within a few seconds the 
> whole machine breaks down complete to the point where no a single pixel 
> is updated and the mouse cannot be moved at all. It's not possible to 
> escape to a ALT-Fn console terminal and CTRL-ALT-DEL does not work.
> 
> Okay, so this is not as bad as winnuke.exe because it's not remote but I 
> just did it on my shared hosting co and their server went down. And I 
> mean seriously, there should be a way for a user to abort stuff that 
> hogs resources this type of complete breakdown is NEVER acceptible. I 
> had to power of the machine and my file system got royally screwed (long 
> fsck etc).
> 
> Some of you might say this is like the oldest trick in the book, yada 
> yada yada...
> 
> 
> 		Martin
> 
> 
> 
> Alan Cox wrote:
> > On Fri, 16 Nov 2007 21:51:27 -0800
> > Martin Olsson <mnemo@minimum.se> wrote:
> > 
> >> Dear kernel hackers,
> >>
> >> This is a message from below 0x7FFFFFFF. Please look at this bug (it's 
> >> not a new concept but still):
> >> https://bugs.launchpad.net/ubuntu/+bug/163185
> > 
> > It seems to want people to register to view it. I guess Ubuntu should fix
> > launchpad then we can see the bug report
> > 
> > Alan
> > -
> 
> 

