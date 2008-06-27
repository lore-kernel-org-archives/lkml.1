Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYF0NE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYF0NE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYF0NEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:04:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47805 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbYF0NEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:04:49 -0400
Date: Fri, 27 Jun 2008 16:02:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>, sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: a.out.h userspace headers not present with O=
Message-ID: <20080627130236.GD18644@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e53d6a152793a38aa334d6f7a4850642ae45cedc
(Export <linux/a.out.h> to userspace again.)
does not work properly when using O= :

<--  snip  -->

linux-2.6.26-rc8$ make O=../out headers_install
...
linux-2.6.26-rc8$ find usr -name a.out.h
linux-2.6.26-rc8$ 

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

