Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZIPO2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZIPO2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZIPO2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:28:32 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:50122 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbZIPO2b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:28:31 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Build error on arm in crypto/cast6.c
Date: Wed, 16 Sep 2009 16:28:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <200909161601.35662.elendil@planet.nl>
In-Reply-To: <200909161601.35662.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909161628.33631.elendil@planet.nl>
X-OriginalArrivalTime: 16 Sep 2009 14:28:33.0732 (UTC) FILETIME=[F86F3040:01CA36D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009, Frans Pop wrote:
> $ git describe master
> v2.6.31-4547-g0cb583f
>
> gcc version 4.3.2
>
> crypto/cast6.c:372:39: error: macro "W" passed 2 arguments, but takes just 1
> crypto/cast6.c:372: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or  ‘__attribute__’ before ‘{’ token
> crypto/cast6.c:413:16: error: macro "W" passed 2 arguments, but takes just 1
> crypto/cast6.c: In function ‘cast6_setkey’:
> crypto/cast6.c:413: error: ‘W’ undeclared (first use in this function)
> crypto/cast6.c:413: error: (Each undeclared identifier is reported only once
> crypto/cast6.c:413: error: for each function it appears in.) 
> crypto/cast6.c:414:20: error: macro "W" passed 2 arguments, but takes just 1
>
> Strange thing is that this file does not look to have changed.
>
> Maybe it's a result of enabling the new config option
> CRYPTO_DEV_MV_CESA?

Seems unrelated. Kernel compiles fine with CRYPTO_DEV_MV_CESA set and
CRYPTO_CAST6 unset. I did have CRYPTO_CAST6 set to m for .31 kernel
builds without seeing any problems.

As I'm running Debian stable there've no major changes (if any) in the
build environment.
