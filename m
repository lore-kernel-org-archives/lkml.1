Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab0BQHNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:13:37 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46398 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0BQHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZI0Pd76HxmeK71h3E7qpPxYEpjo8j9T8LbYvoHiY1NBEJ/Dpt1Ql2aqapZ26FT8OBc
         c4CD37JEKScyQL6vofvzu+9Uou4L/vGHX0y2h+xV4q56cosCrK29G+y3TlkhXFCTjAgs
         +mrQYoafLEUYBNPe5A2u9yyz+A3aCEszdoFbE=
Subject: Re: linux-next: build failure after final merge (net tree)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20100217174015.d1a8a478.sfr@canb.auug.org.au>
References: <20100217174015.d1a8a478.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 08:13:28 +0100
Message-ID: <1266390808.2830.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 17 février 2010 à 17:40 +1100, Stephen Rothwell a écrit :
> Hi Dave,
> 
> After merging, today's linux-next build (sparc64 defconfig) failed like
> this:
> 
> In file included from include/linux/netfilter_ipv4/ip_tables.h:29,
>                  from arch/sparc/kernel/sys_sparc32.c:47:
> include/linux/netfilter/x_tables.h:525: error: expected declaration specifiers or '...' before 'nf_hookfn'
> 
> Caused by commit 2b95efe7f6bb750256a702cc32d33b0cb2cd8223 ("netfilter:
> xtables: use xt_table for hook instantiation").  Missing direct include
> of linux/netfilter.h?
> 

Hi Stephen

David took care of this already.

http://marc.info/?l=linux-netdev&m=126636301220734&w=2


