Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbZA1Rtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbZA1Rtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZA1Rt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:49:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZA1Rt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:49:26 -0500
Message-ID: <49809A65.2090501@kernel.org>
Date: Wed, 28 Jan 2009 09:48:21 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <1233106614.3256.6.camel@localhost.localdomain> <200901281337.52294.arnd@arndb.de>
In-Reply-To: <200901281337.52294.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> For the specific x86 swab code, that would certainly be the simplest
> way, user space should not be using those inline assemblies either
> way.
> 
> I think the more interesting question is whether we want to export
> *any* inline helpers that are not part of the ABI to user space.
> We already killed most of them (spinlocks, atomics, ...) and what
> remains is basically just the byteorder code. All that is required
> for the ABI is the information whether the system is big- or
> little-endian, but not all the rest.
> 

In general, no.  The byteswap API is a legacy exception.

	-hpa

