Return-Path: <linux-kernel-owner+w=401wt.eu-S1764383AbXG2PZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764383AbXG2PZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbXG2PM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:12:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45218 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbXG2PM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:12:27 -0400
Date: Sun, 29 Jul 2007 17:12:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: nvidia installer DIW with 2.6.23-rc1
In-Reply-To: <200707291057.34291.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.64.0707291710440.9488@fbirervta.pbzchgretzou.qr>
References: <200707291057.34291.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-762478449-1185721945=:9488"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-762478449-1185721945=:9488
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jul 29 2007 10:57, Gene Heskett wrote:
>   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c: In 
>function
>   ‘nvidia_init_module’:
>   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c:1326: 
>error:
>   too many arguments to function ‘kmem_cache_create’


>Is this a known problem?  Do I need to report it to nvidia somehow? 

Well, you do not *need* to report it, just as you do not need to report
kernel oopses or Windows crashes. They'll eventually stumble upon
that themselves

>It looks to me like it may be their problem, and I have submitted
>it, but if anyone has a better idea, please advise.  System is FC6,
>uptodate as of yesterday.

Better idea? Fix the source until they have a fix. It seems to be
just an extra argument to kmem_cache_create that got removed.


	Jan
-- 
---699020219-762478449-1185721945=:9488--
