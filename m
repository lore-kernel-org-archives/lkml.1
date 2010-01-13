Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238Ab0AMFLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab0AMFLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998Ab0AMFLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:11:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab0AMFLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:11:20 -0500
Message-ID: <4B4D5329.7050107@zytor.com>
Date: Tue, 12 Jan 2010 20:59:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] irq: handle irq0 special only on x86
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100112155929.GA5615@pengutronix.de>
In-Reply-To: <20100112155929.GA5615@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 07:59 AM, Uwe Kleine-König wrote:
> the feed-back I have got up to now wasn't helpfull.  (Only some "irq0 is
> evil---no it's not" discussion.) So what do you think?  I admit the
> #ifdef isn't nice, but if the semantic is OK I'm willing to rework it
> into something more pretty.

There was a debate on this a long time ago, and the outcome was that IRQ
0 is invalid, across the kernel, and that it is up to each architecture
to carry exceptions (like IRQ 0 for the timer interrupt in x86.)  Hinc
dictat Linus, so you would have to convince him before any of the arch
maintainer could realistically even consider this change.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

