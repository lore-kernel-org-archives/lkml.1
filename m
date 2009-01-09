Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZAIUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZAIUne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZAIUnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:43:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755754AbZAIUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:43:14 -0500
Date: Fri, 9 Jan 2009 12:42:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: Partially defer some of the async stuff to the next release
In-Reply-To: <20090109070910.233e5f3c@infradead.org>
Message-ID: <alpine.LFD.2.00.0901091241470.6528@localhost.localdomain>
References: <20090109070910.233e5f3c@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Arjan van de Ven wrote:
> 
> I think it's better that we defer some of the asynchronous boot stuff to
> 2.6.30 so that it can bake in -next for a bit. I would like to keep the
> core infrastructure in place for 29, so that the various subsystem
> patches etc can just use it in -next without generating dependencies in
> the patch flow.
> 
> for both libata and the inode delete very simple things can be done to
> fix them, but I would feel a lot more comfortable giving these a ride
> in -next.

Can we rather make this something that people can enable with a "fastboot" 
option and is disabled by default? At least that way the ATA people can 
see the problem, and don't just forget about it, since we want it fixed.

		Linus
