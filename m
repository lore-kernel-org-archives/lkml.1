Return-Path: <linux-kernel-owner+w=401wt.eu-S1763441AbXERWkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763441AbXERWkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXERWk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:40:29 -0400
Received: from quechua.inka.de ([193.197.184.2]:33113 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXERWk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:40:28 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Attack
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HpB7Z-000339-00@calista.eckenfels.net>
Date: Sat, 19 May 2007 00:40:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com> you wrote:
>           I found one more interesting thing related with fork
> bombing attack. i have set following in /etc/security/limits.conf file
> 
>     #@root    hard  nproc  3000
>     #@anand hard  nproc  500

The # is a comment character. So those lines are not used.

BTW: the @ means group, you really want that? BTW2: you need to log out/in
and the session leader must actually be PAM regulated (i.e. not for daemons)

So it is good to check "ulimit -n" in the shell where you want to try the
forbomb. If it is below 100 you should be safe.

Gruss
Bernd
