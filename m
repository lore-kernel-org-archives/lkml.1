Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXLFPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXLFPBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLFPBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:01:11 -0500
Received: from r00tworld.com ([212.85.137.21]:56103 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLFPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:01:10 -0500
From: pageexec@freemail.hu
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 06 Dec 2007 15:58:05 +0200
MIME-Version: 1.0
Subject: Re: [patch 06/11] Text Edit Lock - Alternative code for x86
Reply-to: pageexec@freemail.hu
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <47581C0D.20793.3B77EE8@pageexec.freemail.hu>
In-reply-to: <20071206144431.GA11846@Krystal>
References: <20071206020441.851817020@polymtl.ca>, <475804F5.4781.35D49FA@pageexec.freemail.hu>, <20071206144431.GA11846@Krystal>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 06 Dec 2007 15:57:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Dec 2007 at 9:44, Mathieu Desnoyers wrote:

> It is correct to assume that the WP bit will always be activated, in
> every configuration, even though we don't use the DEBUG_RODATA ?

yes, without it the kernel couldn't rely on page faults to trigger
copy-on-write on userland pages for example (just look at what it
has to do on the original i386...).

