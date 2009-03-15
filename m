Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZCOESU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZCOESU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZCOESM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:18:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60958 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbZCOESL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:18:11 -0400
Message-ID: <49BC8182.5050508@cn.fujitsu.com>
Date: Sun, 15 Mar 2009 12:18:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kdebugfs.c cleanup
References: <1237042917.4546.15.camel@ht.satnam>
In-Reply-To: <1237042917.4546.15.camel@ht.satnam>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
> -#include <linux/stat.h>
> +#include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/stat.h>
>  #include <linux/io.h>
>  #include <linux/mm.h>
> -#include <linux/module.h>
>  

Just curious about the rule to sort those includes, and why they need
to be rearranged.

>  #include <asm/setup.h>
>  
