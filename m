Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYGNTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYGNTyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYGNTyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:54:08 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:42709 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYGNTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:54:08 -0400
Date: Mon, 14 Jul 2008 15:54:05 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christian Kujau <lists@nerdbynature.de>
Cc: johnpol@2ka.mipt.ru, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hifn_795x in a MacMini?
Message-ID: <20080714195405.GA28938@phobos.i.cabal.ca>
References: <alpine.DEB.1.10.0807142056190.4469@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807142056190.4469@sheep.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 09:18:09PM +0200, Christian Kujau wrote:
> and after loading the module, dmesg shows:
>
>   Driver for HIFN 795x crypto accelerator chip has been successfully registered.
>

The message is printing by the "module loading" function, which just
registers the pci driver, not the function that actually probes a
device. See hifn_init versus hifn_probe, in drivers/crypto/hifn_795x.c.

r, Kyle
