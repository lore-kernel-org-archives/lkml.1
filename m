Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbXLTJ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbXLTJ5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXLTJ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:57:03 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:42807 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbXLTJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:57:02 -0500
Date: Thu, 20 Dec 2007 10:56:56 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: LKML List <linux-kernel@vger.kernel.org>, jesper.nilsson@axis.com
Subject: Re: What's this __dummy in asm-cris/bitops.h?
Message-ID: <20071220095656.GF10888@axis.com>
References: <47697761.1090702@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47697761.1090702@anagramm.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 08:56:17PM +0100, Clemens Koller wrote:
> Hello,
> 
> while looking for some assembly out of order / optimization stuff
> for something else, I found some strange code in
> .../linux/include/asm-cris/bitops.h:22
> 
> /*
> * Some hacks to defeat gcc over-optimizations..
> */
> struct __dummy { unsigned long a[100]; };
> #define ADDR (*(struct __dummy *) addr)
> #define CONST_ADDR (*(const struct __dummy *) addr)
> 
> CONST_ADDR is never used in the kernel.
> Maybe some -cris people could have a look.

Hmm... This is very old code, it hasn't changed since 2001 and
it is not used anywhere.

I'll send a patch to remove it, thanks for noticing!

> Thanks,
> Clemens Koller

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
