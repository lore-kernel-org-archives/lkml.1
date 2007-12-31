Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXLaMYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXLaMYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbXLaMYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:24:32 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54367 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbXLaMYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:24:31 -0500
Date: Mon, 31 Dec 2007 14:24:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Message-ID: <20071231122419.GA13803@does.not.exist>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 01:09:43PM +0100, Bodo Eggert wrote:
> As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> on normal systems. This is especially true since udev needs these sockets
> and fails to run if UNIX=m.
> 
> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> 
> ---
> Last minute change: I decided against making it a bool because embedded 
> folks might depend on a small kernel image. Edited in the patch below.
>...

Is this just a purely theoretical thought or is this a reasonable use 
case people actually use in practice?

After all, changing it to a bool will allow us to make the kernel image 
for nearly everyone smaller by a few hundred bytes...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

