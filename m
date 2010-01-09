Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225Ab0AIIxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0AIIxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 03:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870Ab0AIIxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 03:53:54 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38713 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0AIIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 03:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=yBKL/dSyPVCiS2MaffaE+ZMv8FpyGQ+CjiHAs0PeYeM1+EcY2gMP7wfnQJuIMrnpQP
         tXmKKwwwH0KD+whdWrV79R0Q3GA8WmfgoHA5/eOelNeW7ef5STHH3frQz97Lzic0qsdP
         8kG9bvCu3s4we4xIv20HGBmBUcN1KGoAsa9K8=
Date: Sat, 9 Jan 2010 11:53:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [announce] smatch 1.54
Message-ID: <20100109085325.GE7840@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a static checker for C.  Download it here:  
http://repo.or.cz/w/smatch.git

These days there are at least seven static checkers people are using 
to check the kernel source.  I can't swear that it's better than all
the others...  Smatch is open source.  It's written in C.  It's based
on sparse.  It's not horribly slow.  It has a git repo that gets updated
every few days.

Really what I would like is for smatch to become a smarter version
of checkpatch.pl.  I'd like it to be something simple, that catches many 
types of common bugs.  Something that people run before submitting code.
It's still probably a year away from being good enough for that.

Since the last release:
	* You need to pass "-p=kernel" to check the kernel source.
	make CHECK="/path/to/smatch -p=kernel" C=1 bzImage

	* The output has been cleaned up.  You can still pass --spammy
	and --info if you want the old output.

	* The array overflow check has improved and finds around 30
	bugs in the 2.6.33-rc2 kernel.

	* There is a new "dma on the stack" check that finds 382
	bugs.  The ones from drivers/usb/serial/ have fixes already.
	This could maybe be rewritten as a Coccinelle script.  The
	fixes are pretty mechanical.

That's the main stuff.

>From what I can tell about the open source checkers is that only the
authors use them.  Smatch has two users besides me (they do userspace 
stuff so they're not on this list), so it's one of the most popular.

Anyway, feedback is always good.  :)

regards,
dan carpenter
