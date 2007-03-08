Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbXCHOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbXCHOyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXCHOyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:54:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:44834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbXCHOyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:54:31 -0500
From: Andreas Schwab <schwab@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] tty: Turn on arbitary baud rate ioctls for i386 platform
References: <20070308144445.31a4e3c4@lxorguk.ukuu.org.uk>
	<1173364787.4568.0.camel@laptopd505.fenrus.org>
X-Yow: HELLO, little boys!   Gimme a MINT TULIP!!  Let's do the BOSSA NOVA!!
Date: Thu, 08 Mar 2007 15:54:20 +0100
In-Reply-To: <1173364787.4568.0.camel@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Thu, 08 Mar 2007 06:39:47 -0800")
Message-ID: <jetzwvyeeb.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> should this then really be in include/asm/* ? If everyone needs the same
> change I'd think it should go into include/linux/* somewhere.

How about asm-generic/ioctls.h?  <asm/ioctls.h> is one of the few ABI
headers for glibc.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
