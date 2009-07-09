Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZGISUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZGISUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZGISUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:20:12 -0400
Received: from www.tglx.de ([62.245.132.106]:51365 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZGISUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:20:11 -0400
Date: Thu, 9 Jul 2009 20:18:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 20/44] includecheck fix: x86, shadow.c
In-Reply-To: <20090709162807.GD5208@lenovo>
Message-ID: <alpine.LFD.2.00.0907092016360.2768@localhost.localdomain>
References: <1247063308.4382.12.camel@ht.satnam> <1247065179.4382.51.camel@ht.satnam> <20090709162807.GD5208@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Cyrill Gorcunov wrote:
> |  #include <linux/kmemcheck.h>
> |  #include <linux/module.h>
> |  #include <linux/mm.h>
> | -#include <linux/module.h>
> |  
> |  #include <asm/page.h>
> |  #include <asm/pgtable.h>
> | -- 
> | 1.6.0.6
> |
> 
> Better to CC Vegard on this.

Can we stop this kindergarden already? The patch is so obvious that it
just should be applied. I'll pick up all x86 ones and fold them in.

Thanks,

	tglx
