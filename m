Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYERSeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYERSeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYERSeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:34:07 -0400
Received: from gw.goop.org ([64.81.55.164]:38022 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYERSeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:34:06 -0400
Message-ID: <4830768B.1090902@goop.org>
Date: Sun, 18 May 2008 19:33:47 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi>
In-Reply-To: <20080518180811.GI8140@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Even more important:
> How do you want to handle kconfig variables set to "m"?
>
> Expand them to 0.5 ?  ;-)
>   

Doesn't much matter.  We can't do "#ifdef CONFIG_FOO == m" anyway.

    J
