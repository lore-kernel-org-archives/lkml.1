Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYHLVzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYHLVzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYHLVy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:54:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38589 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752034AbYHLVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:54:56 -0400
Date: Tue, 12 Aug 2008 22:36:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080812223636.1aff373a@lxorguk.ukuu.org.uk>
In-Reply-To: <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
References: <20080812193031.GD18034@infradead.org>
	<OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Being a TCG/TPM person, I can only address the first question.  The
> intent is that the TPM is soldered to the planar/motherboard (the TCG
> uses the phrase "bound to the platform").  I can't imagine
> any manufacturer designing a pluggable TPM.  It would subvert PCR
> measurements and thus attestation, data sealing, etc.

So the security limit of your TPM is a soldering iron .. whoo. I'm not
sure this is actually the case however as the secret of interest is in
the TPM so even if I replaced the TPM the goodies already set up are in
the TPM I just unsoldered surely ?

Alan
