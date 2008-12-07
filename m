Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYLGLfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYLGLfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYLGLfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:35:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34043 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753402AbYLGLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:35:00 -0500
Date: Sun, 7 Dec 2008 11:35:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] Hw problem or software bug? DMA: Out of SW-IOMMU
 space....
Message-ID: <20081207113512.1e067257@lxorguk.ukuu.org.uk>
In-Reply-To: <12bfabe40812061948w4069e389ub90c4af86a493da6@mail.gmail.com>
References: <12bfabe40812061948w4069e389ub90c4af86a493da6@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2008 04:48:45 +0100
"Giangiacomo Mariotti" <gg.mariotti@gmail.com> wrote:

> I'm running Linux 2.6.27.8.(PS. Today I've sent another e-mail about a
> problem with my new Intel I7 920, but it doesn't seem related except
> for the fact that with 2.6.26.8 neither of them seem to occur.)
> I just read this through dmesg :
> Dec  7 03:33:49 debian-hell kernel: [57102.830078] DMA: Out of
> SW-IOMMU space for 16384 bytes at device 0000:00:1f.2

Either you have something that uses a vast amount of I/O bounce buffer
space or something is leaking it. In the end someone leaked enough that
the disk driver couldn't allocate bounce buffers.

Rather than the gigantic hal dump can you provide an lspci and an lsmod
output. That will give some idea what devices are in use and may help
identify the potential cause.

Alan
