Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbYEVLlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbYEVLlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYEVLla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:41:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47035 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757640AbYEVLla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:41:30 -0400
Date: Thu, 22 May 2008 12:29:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andre Pietsch" <andre.pietsch@scai.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Limit SATA link speed to 1.5 Gbps
Message-ID: <20080522122905.49cca18d@core>
In-Reply-To: <F7D77F204D5F7641AB3864C88E39498F18614E@taube3.scailokal.intern>
References: <F7D77F204D5F7641AB3864C88E39498F18614E@taube3.scailokal.intern>
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

> I tested 2.6.25 and the error still occurrs once but then it gave me a "limiting SATA link speed to 1.5 Gbps" in the log.

The later kernels will drop the SATA speed on repeated errors if they see
what appears to be a consistent problem that might be cabling/noise.

> Is it possible to set the SATA link speed somewhere?

Not sure. I've not looked whether that is in the new "force" code. I
don't think you can in 2.6.24 however, and 2.6.25 will fall back nicely.

Other than being annoying during the install it should not cause any
other problems beyond all the retries.

