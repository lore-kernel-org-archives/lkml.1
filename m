Return-Path: <linux-kernel-owner+w=401wt.eu-S1761407AbXFDVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407AbXFDVXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXFDVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:22:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297AbXFDVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:22:58 -0400
Date: Mon, 4 Jun 2007 14:22:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1: __attribute__((weak)) considered harmful
Message-Id: <20070604142212.c0b68d6a.akpm@linux-foundation.org>
In-Reply-To: <20070602171425.GG5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070602171425.GG5500@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 19:14:25 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch 
> shows why __attribute__((weak)) is harmful because you don't see if a 
> required non-weak implemtation is missing:
> 
> In this case, the weak printk_clock() was renamed to timestamp_clock(), 
> but the ARM and i386 implementations weren't renamed...
> 

printk_clock() is sched_clock() in disguise, and I'm not sure that making
sched_clock() more widely available in this fashion is something that we
want to do anyway.

Anyway, the statistics patches have just celebrated their first birthday
and I don't see that they're getting sufficient momentum or interest to
ever get into mainline so I think I'll drop them, sorry.

