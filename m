Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYCZAGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYCZAGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbYCZAGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:06:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58835 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755785AbYCZAGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:06:39 -0400
Date: Tue, 25 Mar 2008 23:49:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: <jgarzik@pobox.com>, Linux IDE <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pata_sil680: Only enable MMIO on Cell blades
Message-ID: <20080325234929.7c52d5c6@core>
In-Reply-To: <20080325235112.C29CDDE1D9@ozlabs.org>
References: <20080325235112.C29CDDE1D9@ozlabs.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 10:50:41 +1100
Benjamin Herrenschmidt <benh@ozlabs.org> wrote:

> There have been reported regressions of the SIL 680 driver when
> using MMIO, so this makes it only try MMIO on Cell blades where
> it's known to be necessary (the host bridge doesn't do PIO on these).
> 
> We'll try to find the root problem with MMIO separately.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Alan Cox <alan@redhat.com>
