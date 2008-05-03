Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbYECR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbYECR1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbYECR1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:27:24 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1167 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761868AbYECR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:27:23 -0400
Subject: Re: [PATCH 1/2] OF: clean coding style - prom_parse.c
From: Joe Perches <joe@perches.com>
To: monstr@seznam.cz
Cc: paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>
In-Reply-To: <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu>
References: <monstr@seznam.cz>
	 <1209827626-8562-1-git-send-email-monstr@seznam.cz>
	 <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu>
Content-Type: text/plain
Date: Sat, 03 May 2008 10:26:22 -0700
Message-Id: <1209835583.16966.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-03 at 17:13 +0200, monstr@seznam.cz wrote:
>  /* Debug utility */
>  #ifdef DEBUG
>  static void of_dump_addr(const char *s, const u32 *addr, int na)
>  {
> -	printk("%s", s);
> -	while(na--)
> -		printk(" %08x", *(addr++));
> -	printk("\n");
> +	printk(KERN_INFO "%s", s);
> +	while (na--)
> +		printk(KERN_INFO " %08x", *(addr++));
> +	printk(KERN_INFO "\n");
>  }

You've prefixed KERN_INFO before every address block.

How about:

print_hex_dump(KERN_<level>, s, DUMP_PREFIX_NONE, 4, addr, na, false);

