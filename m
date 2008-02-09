Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYBIVh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYBIVh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYBIVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:37:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYBIVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:37:18 -0500
Message-ID: <47AE1C88.9020005@zytor.com>
Date: Sat, 09 Feb 2008 13:35:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some	processors
References: <200802082347.25364.michael-lists@free-electrons.com>	 <1202512812.17934.680.camel@cinder.waste.org> <1202545817.6722.24.camel@odie.local> <47AD725E.6050903@free-electrons.com>
In-Reply-To: <47AD725E.6050903@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Opdenacker wrote:
> Thanks for this report. Don't you think it's still useful to save up to
> 12 K of code that you don't use if you just have an Intel processor (for
> example)?

For 12K it better be a very clean patch... which I don't consider this 
patch to be; it has way too many #ifdefs in the code.

	-hpa
