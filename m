Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYFPMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYFPMSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYFPMSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:18:47 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59038 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYFPMSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:18:46 -0400
Date: Mon, 16 Jun 2008 15:17:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: Re: [PATCH v2] export linux/a.out.h
Message-ID: <20080616121727.GB10854@cs181133002.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org> <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1213617663.26255.708.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 01:01:03PM +0100, David Woodhouse wrote:
>...
> David Woodhouse (6):
>...
>       Remove references to now-defunct CONFIG_ARCH_SUPPORTS_AOUT from defconfigs

Please don't do this kind of defconfig updates - it doesn't bring any 
advantage but can create tons of patch conflicts.

The next time a defconfig gets updated it will anyway automatically be 
fixed, and for defconfigs that aren't updated it doesn't create any 
problems to keep them as they are today until they might one day get 
updated.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

