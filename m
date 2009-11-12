Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZKLSBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZKLSBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZKLSBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:01:39 -0500
Received: from snt0-omc1-s25.snt0.hotmail.com ([65.55.90.36]:40658 "EHLO
	snt0-omc1-s25.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbZKLSBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:01:38 -0500
Message-ID: <SNT125-W33733E48300A2E2D156865C3A90@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <kees.cook@canonical.com>
CC: <arjan@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
       <x86@kernel.org>, <penberg@cs.helsinki.fi>, <jbeulich@novell.com>,
       <vegardno@ifi.uio.no>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: RE: [PATCH v4] [x86] detect and report lack of NX protections
Date: Thu, 12 Nov 2009 10:01:44 -0800
Importance: Normal
In-Reply-To: <20091110205544.GZ5129@outflux.net>
References: <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com>
 <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com>
 <20091110165738.GH5129@outflux.net> <4AF99F0C.2050806@zytor.com>
 <20091110174622.GK5129@outflux.net>
 <4AF9B6AD.8020505@zytor.c,<20091110205544.GZ5129@outflux.net>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Nov 2009 18:01:44.0246 (UTC) FILETIME=[31B87D60:01CA63C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> The last column should actually be "no message", "impossible", "impossible".
>
> Ah, yes, very true.
Nope, not only can it be disabled in the BIOS, but also don't forget Intel's first D0 stepping Nocona Xeon x86-64 CPUs, which do not have NX.
> (the class of machines without PAE being
> larger than those without NX and with PAE).Nope also. Clue: Most post-Pentium Pro Intel CPUs and all AMD CPUs since the K7 has PAE available as a CPU feature.
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
http://clk.atdmt.com/GBL/go/171222986/direct/01/