Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbXJPAPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbXJPAPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXJPAPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:15:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbXJPAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:15:33 -0400
Message-ID: <471401AF.4090802@zytor.com>
Date: Mon, 15 Oct 2007 17:11:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
CC: Arjan van de Ven <arjan@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz> <20071015143732.01d99af8@laptopd505.fenrus.org> <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:
> 
> I know about unordered stores (movnti & similar) --- they basically use 
> write-combining method on memory that is normally write-back --- and they 
> need sfence. But which one instruction does unordered load and needs 
> lefence?
> 

PREFETCHNTA.

	-hpa
