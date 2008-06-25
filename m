Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYFYUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYFYUcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYFYUcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:32:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46912 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbYFYUcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:32:14 -0400
Date: Wed, 25 Jun 2008 21:14:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Agner Fog <agner@agner.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080625211443.690855b9@lxorguk.ukuu.org.uk>
In-Reply-To: <48626514.2040905@agner.org>
References: <48626514.2040905@agner.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3. When compiling a device driver, the compiler may insert implicit 
> calls to library functions such as memcpy and memset. These functions 
> typically have a CPU dispatcher that chooses the largest register size 
> available. The device driver may therefore use YMM registers without the 
> knowledge of the programmer and without compiling with the AVX switch on.

Linux uses its own routines in these cases - and in fact for MMX we
generally avoid kernel usage in order to avoid the overheads (ditto FP).

> A decision on this question should be made and published in the ABI so 
> that people can make compatible device drivers.

The beauty of the Linux kernel being source based - we don't have to worry
about ABI problems like this.

Alan

