Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZKRKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZKRKU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZKRKU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:20:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:45897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZKRKUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:20:25 -0500
Message-ID: <4B03CA6E.8080102@suse.cz>
Date: Wed, 18 Nov 2009 11:20:30 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kconfig: Add missing prototype
References: <b9df5fa10911180212h5d74e640g859e7cebe952689@mail.gmail.com>
In-Reply-To: <b9df5fa10911180212h5d74e640g859e7cebe952689@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.11.2009 11:12, Rakib Mullick napsal(a):
>   Patch named 'kbuild-generate-modulesbuiltin.patch' introduce a new
> function 'fprintf2', without previous prototype declared. This patch adds
> this missing prototype.

Hi Rakib,

thanks for the fix, but I already posted a new, simplified version that
doesn't use the fprintf2() thing at all:
http://patchwork.kernel.org/patch/50131/

Michal


>  When building defconfig on i386 - we were hit by the following warning:
> 
>   HOSTCC  scripts/kconfig/zconf.tab.o
> In file included from scripts/kconfig/zconf.tab.c:2451:
> scripts/kconfig/confdata.c:676: warning: no previous prototype for 'fprintf2'
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> --- linus/scripts/kconfig/lkc.h	2009-11-18 16:37:46.000000000 +0600
> +++ rakib/scripts/kconfig/lkc.h	2009-11-18 17:03:19.000000000 +0600
> @@ -79,6 +79,7 @@ char *conf_get_default_confname(void);
>  void sym_set_change_count(int count);
>  void sym_add_change_count(int count);
>  void conf_set_all_new_symbols(enum conf_def_mode mode);
> +int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...);
> 
>  /* kconfig_load.c */
>  void kconfig_load(void);

