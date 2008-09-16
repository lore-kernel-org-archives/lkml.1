Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYIPRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYIPRBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYIPRBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:01:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58064 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358AbYIPRA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:00:58 -0400
Date: Tue, 16 Sep 2008 18:00:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux@sandersweb.net, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all
 systems support it.
Message-ID: <20080916180022.5f57368b@lxorguk.ukuu.org.uk>
In-Reply-To: <48CFDF82.3000704@zytor.com>
References: <200809161159.15870.linux@sandersweb.net>
	<48CFDF82.3000704@zytor.com>
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

> Given that, we should either just rip this code out, or detect VPC 
> (how?).  The latter option can be done post-.27, of course; if so, we 

Make the user pass a "vpcworkarounds" boot option...

