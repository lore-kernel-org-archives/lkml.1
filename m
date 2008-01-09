Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYAIVCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYAIVCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYAIVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:01:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbYAIVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:01:56 -0500
Message-ID: <47853537.4070702@zytor.com>
Date: Wed, 09 Jan 2008 12:57:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: More breakage in native_rdtsc out of line in git-x86
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu> <20080109174800.GA15346@one.firstfloor.org> <20080109122559.38bc8c33@laptopd505.fenrus.org> <20080109204028.GA15612@one.firstfloor.org>
In-Reply-To: <20080109204028.GA15612@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> People tend to make jokes about optimizing the idle loop too, but they're
> actually wrong. Exit latency for the idle loop is important -- it 
> decides how quickly you can react to load changes on idle CPUs.
> 
> For short udelays I suspect shorter exit latency is also moderately useful.
> 
> But anyways there are plenty of gtod users outside the X server.
> 
> e.g. common not user space case is packet timestamps.
> 

It's also very common to put gtod calls around select and poll, because 
the standard interface doesn't tell you how long you have been away 
(Linux at least used to have it, but glibc "fixed" that...)

	-hpa
