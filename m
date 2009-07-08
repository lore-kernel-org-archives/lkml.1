Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZGHVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZGHVd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZGHVdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:33:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbZGHVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:33:49 -0400
Message-ID: <4A55109C.7040506@zytor.com>
Date: Wed, 08 Jul 2009 14:33:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic -- don't forget to disconnect BSP discrete
 apic
References: <20090708200741.GI5301@lenovo>
In-Reply-To: <20090708200741.GI5301@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> In case of discrete APIC cpu_has_apic could be not set.
> This leads to disconnect_bsp_APIC is not called where
> it should.

I thought we were going to turn on cpu_has_apic in this case?

	-hpa

