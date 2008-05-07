Return-Path: <linux-kernel-owner+w=401wt.eu-S934231AbYEGXEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbYEGXEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYEGXET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:04:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765539AbYEGXER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:04:17 -0400
Message-ID: <4822353D.8050308@zytor.com>
Date: Wed, 07 May 2008 16:03:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Henry Nestler <henry.nestler@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
 2.6 - v2
References: <480E6BB4.5080902@henry.nestler.gmail.com> <20080428164455.GB18210@elte.hu> <48221695.7060507@henry.nestler.gmail.com>
In-Reply-To: <48221695.7060507@henry.nestler.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henry Nestler wrote:
> Shure, the "out of range address" was from buggy driver development.
> But not of adresses should kill the complete system.

Actually, that's the normal thing to happen for kernel code poking at an 
address it shouldn't.

It should do it cleanly, via an oops, though.

	-hpa
