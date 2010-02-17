Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab0BQXA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:00:26 -0500
Received: from snt0-omc2-s38.snt0.hotmail.com ([65.55.90.113]:12805 "EHLO
	snt0-omc2-s38.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab0BQXAZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:00:25 -0500
Message-ID: <SNT125-W19438E1E5A7FB2F02097DEC3480@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <luca@luca-barbieri.com>
CC: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 10/10] x86-32: panic on !CX8 && XMM
Date: Wed, 17 Feb 2010 15:00:25 -0800
Importance: Normal
In-Reply-To: <4B7C6FC8.7090107@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
 <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>,<4B7C6FC8.7090107@zytor.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 Feb 2010 23:00:24.0898 (UTC) FILETIME=[FD54BA20:01CAB024]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> NAK in the extreme.
>
> This is not how we deal with these kinds of stuff. If this really
> matters, we explicitly clear the CPU feature in the feature detect code.
Also, don't forget the NT4 CX8 bug with non-Intel/AMD/Cyrix vendors:
http://www.geoffchappell.com/studies/windows/km/cpu/cx8.htm
If a processor support SSE (or PAE or MMX for that matter), you can pretty much assume CX8 exists even if the feature bit is cleared because of this bug.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/201469226/direct/01/