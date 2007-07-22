Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXGVSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXGVSFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbXGVSFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:05:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXGVSFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:05:34 -0400
Message-ID: <46A39C64.9070301@zytor.com>
Date: Sun, 22 Jul 2007 11:05:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070720212741.GB565@one.firstfloor.org> <46A12A3A.4020305@zytor.com> <20070722091826.GA28313@one.firstfloor.org>
In-Reply-To: <20070722091826.GA28313@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The main reason is that everyone seems to invoke it either incorrectly
> Where is it incorrect? 

Using "r" or "m" (as opposed as "+m") gives gcc the wrong dependency
information, and it could, at least in theory, cause memory references
to be moved around it -- especially when using "r".

	-hpa
