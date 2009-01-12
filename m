Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZALMKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZALMKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZALMJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:09:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:60397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750720AbZALMJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:09:59 -0500
X-Authenticated: #6028172
X-Provags-ID: V01U2FsdGVkX18V2tAaA/UVOgNNwZsoeYIfU3AH2gxnhTLVIyrD7U
	Bb2c6rQ1KJemFE
Message-ID: <496B3331.1070709@gmx.de>
Date: Mon, 12 Jan 2009 13:10:25 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>, travis@sgi.com,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu>
In-Reply-To: <20090112112608.GB19388@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> Dieter did not have lockdep enabled so we dont have a nice stack
> trace proof for this, but using work_on_cpu() in such a lowlevel
> place certainly looks wrong, so we revert the patch.

I can send a stack trace in the evening, when I have access to my other
machine for getting the netconsole output. Would that help?

cu
Dieter
