Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYDXKIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYDXKIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYDXKH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:07:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38931 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751614AbYDXKH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:07:56 -0400
Date: Wed, 23 Apr 2008 19:19:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
Message-ID: <20080423191952.77b56569@the-village.bc.nu>
In-Reply-To: <480B9ADD.9060105@zytor.com>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>
	<480AC505.1030301@zytor.com>
	<877ies9x6b.fsf@basil.nowhere.org>
	<480B9856.3040902@gmail.com>
	<480B9ADD.9060105@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 15:34:53 -0400
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Dmitri Vorobiev wrote:
> >>
> >> Also NexGen was never shipped anyways, but bought by AMD and became
> >> the K6. So I assume whatever this file is supposed to do is done
> >> by amd.c anyways.
> > 
> > IOW, you claim that now it's safe enough to throw away the NexGen
> > altogether?
> > 
> 
> If it never shipped, then yes, it should be safe to remove.  We don't 
> support other vendors that never went to product, e.g. RISE or Montalvo.

There are/were a few Nexgen boxes out there - strange beast where the
BIOS code emulated some instructions. So few I doubt killing it off is a
problem at all.

Alan
