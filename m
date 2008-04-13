Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYDMTyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYDMTyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYDMTs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:48:57 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47077 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbYDMTs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:48:56 -0400
Date: Sun, 13 Apr 2008 22:47:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mfd/sm501.c: #if 0 unused functions
Message-ID: <20080413194755.GB13920@cs181133002.pp.htv.fi>
References: <20080413181531.GD2182@cs181133002.pp.htv.fi> <9a8748490804131155g3df93ba7s9c2131a957391ee3@mail.gmail.com> <20080413190326.GB21204@cs181133002.pp.htv.fi> <9a8748490804131208o220cd763k33b74d547911a8f0@mail.gmail.com> <20080413192420.GC21204@cs181133002.pp.htv.fi> <9a8748490804131234v26fefe9dp633fd0509b0fff6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a8748490804131234v26fefe9dp633fd0509b0fff6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 09:34:24PM +0200, Jesper Juhl wrote:
>...
> Please don't see my comments as complaints. They are not intended as
> such. I'm merely currious why we keep adding all these '#if 0's since
> I don't see the point and I can just see them piling up into some huge
> janitorial mountain from hell to be tackled some time in the future by
> whomever is masochistic enough to try ;-)

The main advantage of the #if 0 solution is that it not only stops 
bloating the kernel image, but in the frequent "I might need it some day" 
case I can simply say "no problem with my patch - just remove the #if 0".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

