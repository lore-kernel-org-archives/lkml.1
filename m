Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYIOB0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYIOB0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 21:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIOBZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 21:25:58 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57770 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYIOBZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 21:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=DZr53+CTz2LksBXLbQ3YDBZGWEAzY9F1ezh22d8ZIPEA6by6nwZErWUr51DLG8L6RB
         lHXVv72FO+0bFzc9G/06jNssR/YPy71Fp2Dx0a6MQLP8ejjKqeaouZ+n/9Y3dVA3uVv9
         9wmaLms9IEtMNDAagyMIQWluWHiqp1e2l0AzI=
Message-ID: <514e099a0809141825u34015891pa3f11267373ae818@mail.gmail.com>
Date: Sun, 14 Sep 2008 18:25:55 -0700
From: "S K" <nospamnoham@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Unable to find files in include/asm-arm in the Linus's tree
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I think the copy paste of the terminal will explain it better:

$ git status
# On branch master
nothing to commit (working directory clean)

$ cat .git/config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master

$ ls include/asm-arm/
plat-s3c  plat-s3c24xx

Where are the other files? I'm totally confused. Doesn't Linus's tree
have the code for all archs?

It obvious from the status I didn't delete them, but even a
$ git reset --hard HEAD
didn't help.

Thanks,
SK
