Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbXFBRO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbXFBRO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXFBROX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:14:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51827 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760895AbXFBROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:14:22 -0400
Date: Sat, 2 Jun 2007 19:14:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc3-mm1: __attribute__((weak)) considered harmful
Message-ID: <20070602171425.GG5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch 
shows why __attribute__((weak)) is harmful because you don't see if a 
required non-weak implemtation is missing:

In this case, the weak printk_clock() was renamed to timestamp_clock(), 
but the ARM and i386 implementations weren't renamed...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

