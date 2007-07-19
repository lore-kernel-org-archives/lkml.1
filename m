Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXGSGuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXGSGuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXGSGuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:50:05 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:36287 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbXGSGuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:50:01 -0400
Date: Thu, 19 Jul 2007 08:50:12 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: pvp@tk.ru.acad.bg
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-git10 compile error
Message-ID: <20070719085012.19fa2df7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <469F048A.5070003@tk.ru.acad.bg>
References: <469F048A.5070003@tk.ru.acad.bg>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 09:28:26 +0300,
Plamen Petrov <plamen.petrov@tk.ru.acad.bg> wrote:

> Hi, all!
> 
> Just for the record - linux kernel version 2.6.22-git10 fails to build
> with the following error:
> 
> In file included from net/netfilter/xt_connlimit.c:27:
> include/net/netfilter/nf_conntrack.h:99: error: field `ct_general' has 
> incomplete type
> include/net/netfilter/nf_conntrack.h: In function `nf_ct_get':
> include/net/netfilter/nf_conntrack.h:163: error: structure has no member 
> named `nfct'
> include/net/netfilter/nf_conntrack.h: In function `nf_ct_put':
> include/net/netfilter/nf_conntrack.h:170: error: implicit declaration of 
> function `nf_conntrack_put'
> include/net/netfilter/nf_conntrack.h: In function `nf_ct_is_untracked':
> include/net/netfilter/nf_conntrack.h:252: error: structure has no member 
> named `nfct'
> In file included from net/netfilter/xt_connlimit.c:28:
> include/net/netfilter/nf_conntrack_core.h: In function 
> `nf_conntrack_confirm':
> include/net/netfilter/nf_conntrack_core.h:68: error: structure has no 
> member named `nfct'
> make[2]: *** [net/netfilter/xt_connlimit.o] Error 1
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2

This is fixed with commit 3fd8f9e4b6c184d03d340bc86630f700de967fa8.
