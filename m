Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbYDLLEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbYDLLEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 07:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbYDLLE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 07:04:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34316 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759803AbYDLLEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 07:04:20 -0400
Date: Sat, 12 Apr 2008 11:59:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
Message-ID: <20080412115950.1cbb9cfa@core>
In-Reply-To: <m3prsva3y7.fsf@maximus.localdomain>
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
	<m33aqedg0a.fsf@maximus.localdomain>
	<m37if4oz1g.fsf@maximus.localdomain>
	<20080411221448.22b69ff5.akpm@linux-foundation.org>
	<m3prsva3y7.fsf@maximus.localdomain>
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

On Sat, 12 Apr 2008 10:10:40 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > It never hurts to resend.  It was 6000 patches ago and my mind is a blank.
> 
> Sure, here is it. Some description, well:
> 
> PPP support in generic HDLC in Linux 2.6.25 is broken and will cause
> a kernel panic when a device configured in PPP mode is activated.
> 
> It will be replaced by new PPP implementation after Linux 2.6.25 is
> released.

Thats a pretty bad regression. Surely the correct fix is to revert the
change series that caused the breakage then re-merge that and fixes for
HDLC PPP for 2.6.26, not just leave it broken ?
