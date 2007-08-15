Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXHOHmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXHOHmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXHOHmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:42:06 -0400
Received: from quechua.inka.de ([193.197.184.2]:37142 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbXHOHmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:42:04 -0400
X-Greylist: delayed 2211 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 03:42:04 EDT
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: do_coredump and O_NOFOLLOW
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <46C290F6.2090309@alcatel-lucent.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1ILCwJ-0003th-00@calista.eckenfels.net>
Date: Wed, 15 Aug 2007 09:05:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <46C290F6.2090309@alcatel-lucent.com> you wrote:
> I found that O_NOFOLLOW is used for opened core file in Linux 2.6.10. 

I think that is for security reasons, otherwise one has to (atomically)
check who is the owner of the symlink and where it points to. If you dont
have hostile users on your system you might be able to remove it, but it is
not a good idea in the general public.

Maybe we need a coreadm tool like Solaris has, where you can put the
corefiles where you want. That would change the corepattern to include a
path and be specific to a process (tree).

Gruss
Bernd
