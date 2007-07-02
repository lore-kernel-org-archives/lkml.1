Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXGBEOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXGBEOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 00:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXGBEOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 00:14:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:43001 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXGBEON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 00:14:13 -0400
Subject: Re: [Cbe-oss-dev] [PATCH 1/1] Fix elf_core_dump() when writing
	arch specific notes (spu coredumps)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>, linux-arch@vger.kernel.org,
       Arnd Bergmann <arnd.bergmann@de.ibm.com>, linux-kernel@vger.kernel.org,
       ak@suse.de, petr@vandrovec.name, cbe-oss-dev@ozlabs.org
In-Reply-To: <67867aa5e78ae107a62706a33a2aa643e8244256.1183016719.git.michael@ellerman.id.au>
References: <67867aa5e78ae107a62706a33a2aa643e8244256.1183016719.git.michael@ellerman.id.au>
Content-Type: text/plain
Date: Mon, 02 Jul 2007 14:13:39 +1000
Message-Id: <1183349619.10386.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 .../...

> While I'm here I should point out that the spu coredump code does not work
> if we're dumping to a pipe - we'll have to wait for 23 to fix that.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Ugly but I suppose we can't do better for 2.6.22

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


