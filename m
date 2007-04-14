Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXDNFh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXDNFh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 01:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161098AbXDNFh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 01:37:28 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:51568 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161024AbXDNFh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 01:37:27 -0400
Message-ID: <46206842.80203@gmail.com>
Date: Sat, 14 Apr 2007 07:36:02 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>, git@vger.kernel.org
Subject: GIT and the current -stable
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

Stumbling around with git here. I'd like to use git to efficiently track the 
  current -stable as well as -current. Say, my local tree is a clone of 
Linus current:

git clone \ 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git local

I then branch off a 2.6.20 branch:

cd local
git checkout -b v2.6.20 v2.6.20

to now update to the current -stable I could do:

git pull \ 
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

each time that a new -stable is released. Rather though, I'd like a simple 
"git pull" to do this while on this branch while a "git pull" while back on 
the master branch pulls from the originally cloned Linus repo again.

Is this possible? Do I want it to be? Comments like "work like this instead" 
welcome as well; figuring out what the heck it is that I want from git seems 
to be one of the most difficult questions to answer...

Currently using git 1.5.0.4.

Rene.

