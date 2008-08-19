Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYHSTxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYHSTxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYHSTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:52:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60795 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbYHSTwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:52:50 -0400
Date: Tue, 19 Aug 2008 22:52:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: inclusion of <endian.h> in a kernel header? ok or not?
Message-ID: <20080819195239.GA21209@cs181140183.pp.htv.fi>
References: <ac9c93b10808191216q64c41222n7752c24c089e3303@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac9c93b10808191216q64c41222n7752c24c089e3303@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 09:16:56PM +0200, Frans Meulenbroeks wrote:
> Is it ok to #include <endian.h> in a kernel header file.
> This is done in linux/patchkey.h and linux/soundcard.h but other
> places seem to prefer <asm/byteorder.h>
>...

Look at the two files you mention - they only do it in userspace.

And considering that these only users in the kernel are in the OSS code
it's most likely not the best solution.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

