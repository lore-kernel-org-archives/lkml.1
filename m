Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZI2PgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZI2PgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZI2PgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:36:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZI2PgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:36:10 -0400
Message-ID: <4AC2288E.3060309@zytor.com>
Date: Tue, 29 Sep 2009 08:32:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de, torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
References: <20090928113433.5e9b8ea7@infradead.org> <200909291444.06422.arnd@arndb.de>
In-Reply-To: <200909291444.06422.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 05:44 AM, Arnd Bergmann wrote:
> 
> The patch looks good, but is there a reason to keep it architecture
> specific? I would guess that the same logic applies to all architectures
> with gcc-4.x and could be put into include/linux/compiler-gcc4.h.
> 

Each architecture has its own implementation, and in some cases gcc will
even generate code which is illegal in the kernel.  It really needs to
be enabled by each architecture.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

