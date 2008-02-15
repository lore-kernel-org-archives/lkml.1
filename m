Return-Path: <linux-kernel-owner+w=401wt.eu-S1764801AbYBODFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764801AbYBODFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbYBODFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:05:12 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35484 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620AbYBODFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:05:10 -0500
Message-ID: <47B501C8.4000301@keyaccess.nl>
Date: Fri, 15 Feb 2008 04:06:48 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Emelyanov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported	symbols
 going away
References: <1202941327.18204.11.camel@brick>
In-Reply-To: <1202941327.18204.11.camel@brick>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.2 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-08 23:22, Harvey Harrison wrote:

> +---------------------------
> +
> +What:	io_delay_type
> +Where:	arch/x86/kernel/io_delay.c
> +When:	2.6.28
> +Why:	No in tree users

The entirety of io_delay.c should be gone long before .28. It's a short term 
thing till the port 0x80 problems have been dealt with.

Rene.
