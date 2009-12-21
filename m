Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZLUNjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZLUNjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZLUNjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:39:12 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:51565 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbZLUNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:39:12 -0500
Message-ID: <4B2F7A95.3010708@byu.net>
Date: Mon, 21 Dec 2009 06:39:33 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp> <4B2F7421.10005@byu.net>
In-Reply-To: <4B2F7421.10005@byu.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Eric Blake on 12/21/2009 6:12 AM:

It may also be file-system dependent.  On the machine where I saw the
original failure:
> $ uname -a
> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
> x86_64 GNU/Linux

$ df -T .
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data

But on the machine where the test case is working:
> $ uname -a
> Linux vladim 2.6.31.6-166.fc12.i686 #1 SMP Wed Dec 9 11:14:59 EST 2009
> i686 GNU/Linux

$ df -T .
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda3     ext3    34123236  25894932   6494892  80% /

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
