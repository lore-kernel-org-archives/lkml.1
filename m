Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXHNL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXHNL1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbXHNL1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:27:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42767 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754183AbXHNL1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:27:01 -0400
Date: Tue, 14 Aug 2007 12:34:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@argo.co.il>
Cc: hinoue@ccsl.carleton.ca, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070814123425.4f61b42f@the-village.bc.nu>
In-Reply-To: <46C139BD.1030607@argo.co.il>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
	<20070814000956.7c8929dd@the-village.bc.nu>
	<46C139BD.1030607@argo.co.il>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 08:12:29 +0300
Avi Kivity <avi@argo.co.il> wrote:

> Alan Cox wrote:
> > This is to protect it from being changed by an attacker or someone trying
> > to do strange and bogus things to the kernel.
> >   
> 
> Someone who apparently hasn't heard of vmap(), etc.
> 
> It's a debug aid at best.

You assume the average attacker is smart. Fortunately this isn't true,
although some certainly are. For guests however we can push this further
as a hypervisor can implement 'irrevocably read only' pages for a guest.
Something we don't currently do but should.

Alan
