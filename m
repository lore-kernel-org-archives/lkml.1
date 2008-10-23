Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYJWSdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYJWSdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYJWSdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:33:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:42690 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJWSdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jHOskXNjXZicePnwg4/hLQNc8JhD89s+8JFqDvlVM6uLu30GXJE16iHEYdhff78wty
         aa1YH0+RWUNyBubcgiEQS8t0W8oZ7bQeaDPRMvQV/dkODp0v8fcXA2IrZkkXDiM8vF3C
         MX7xSd5NYipusxKJTPBgcU6f8wCLUedPx6O8c=
Date: Thu, 23 Oct 2008 22:36:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] /proc update
Message-ID: <20081023183649.GA13432@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please, pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc

to get
a) /proc/*/smaps fix aka "[vsyscall] is listed twice"
b) proc_misc.c disintegration patches which spread that collective
   dumping ground into sensible pieces,
c) trivial things.

Regarding (b), it wasn't in -next because of huge rejects, it wasn't in
-mm because of huge rejects, but (!) various people acked pieces, it was
booted in several configurations here and proc files were created and
worked as usual, it's trivial.

Also, looks like, I can't put it into -next or into -mm and keep it for
several months there because of rejects, and keeping it out of system
will buy me approximately the same amount of testing as there is now.

However, fs/proc/ compiliation was tested on huge cross-compile setup here
and many, many randconfigs without warnings or errors.

Now, if you don't buy it, pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-conservative

to get just /proc/*/smaps fix and trivial things.
