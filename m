Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbXESSNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbXESSNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbXESSNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:13:16 -0400
Received: from quechua.inka.de ([193.197.184.2]:35654 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420AbXESSNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:13:15 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: it seems at XFS bug?!
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HpTQX-0001hN-00@calista.eckenfels.net>
Date: Sat, 19 May 2007 20:13:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com> you wrote:
> -rw-r--r-- 1 root root      0 2007-05-06 12:41
> 
> the last line is very interesting, this file has no name and the size is 0 byte.

Well, 0 byte files are nothing special, and the name: it might be a non-printable char?

> touch ' '

will produce a similiar file. Try "ls -li | od -cx"

Greetings
Bernd
