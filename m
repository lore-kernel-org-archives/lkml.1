Return-Path: <linux-kernel-owner+w=401wt.eu-S938240AbXHLTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938240AbXHLTtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936413AbXHLTtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:49:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34771 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936535AbXHLTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:49:04 -0400
Date: Sun, 12 Aug 2007 21:49:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mark Cannon <random.bits@rogers.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
In-Reply-To: <200708121539.48332.random.bits@rogers.com>
Message-ID: <Pine.LNX.4.64.0708122147440.28963@fbirervta.pbzchgretzou.qr>
References: <200708101724.26724.random.bits@rogers.com> <46BCFE01.2040703@zytor.com>
 <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
 <200708121539.48332.random.bits@rogers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 15:39, Mark Cannon wrote:
>> >> No, but you can use pivot_root.
>> >
>> >Or better yet, use an initramfs with MS_MOVE; same as you would with the
>> >"normal" use of initramfs.
>
>I am not sure I understand initramfs with MS_MOVE concept. I will look into
>it. Any pointers for documentation? 

pivot_root is atomic afaict, for `mount --move` (which I think Al meant 
which MS_MOVE - or some C program using mount(2) of your own), you'd 
need multiple calls to mount.


	Jan
-- 
