Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYCaV2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYCaV2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbYCaV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:27:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:37089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbYCaV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NWQlMno88DOIZn8wiCm7jE9ay73Wr1w+IAz2lk2Xcd68L/kAgQXz9nkKLgzwi3QUcD9fiIHzLe5h3oRfokPRKvIT6Nhebk01zRFKi2JkDe622fj/TJTevywsH4UhtPGye3+fK65eH+6lbsyApjb5wQ25xpGMR4tth4oEAMrng/A=
Message-ID: <47F15737.3080402@gmail.com>
Date: Mon, 31 Mar 2008 23:27:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Char: ip2, macros cleanup
References: <20080328032449.cbc09f3b.akpm@linux-foundation.org> <1206739124-3875-2-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1206739124-3875-2-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2008 10:18 PM, Jiri Slaby wrote:
> - remove i2os.h -- there was only macro to macro renaming or useless
>   stuff
> - remove another uselless stuf (NULLFUNC, NULLPTR, YES, NO)
> - use outb/inb directly
> - use locking functions directly
> - don't define another ROUNDUP, use roundup(x, 2) instead
> - some comments and whitespace cleanup
> - remove some commented crap
> - prepend the rest by I2 prefix to not collide with rest of the world
>   like in following output (pointed out by akpm)
> 
> In file included from drivers/char/ip2/ip2main.c:128:
> drivers/char/ip2/i2ellis.h:608:1: warning: "COMPLETE" redefined
> In file included from include/net/netns/ipv4.h:8,
>                  from include/net/net_namespace.h:13,
>                  from include/linux/seq_file.h:7,
>                  from include/asm/machdep.h:12,
>                  from include/asm/pci.h:17,
>                  from include/linux/pci.h:951,
>                  from drivers/char/ip2/ip2main.c:95:
> include/net/inet_frag.h:28:1: warning: this is the location of the previous definition
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

NACK, this one is crap, ignore it.

