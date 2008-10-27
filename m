Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbYJ0Oie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbYJ0Oie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYJ0OiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:38:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbYJ0OiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:38:22 -0400
Message-ID: <4905D189.9080306@zytor.com>
Date: Mon, 27 Oct 2008 07:34:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joe Damato <ice799@gmail.com>, linux-x86_64@vger.kernel.org,
       linux-newbie@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs
References: <1224904532-9586-1-git-send-email-ice799@gmail.com> <20081027105559.GA13895@elte.hu>
In-Reply-To: <20081027105559.GA13895@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Small detail, the syntactic form you chose:
> 
> +       if (!cpu->arch.idt[num].p)
> 
> is not very readable because it's not obvious at first sight that ".p" 
> intends to mean "present bit". If then idt[num].present would have 
> been the better choice - but it's even better to not do bitfields at 
> all but an idt_present(desc *) helper inline function.
> 

There is, however, some benefit to use the field names that are in the 
official documentation, which include P.

	-hpa
