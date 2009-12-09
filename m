Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZLIUHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZLIUHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbZLIUHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:07:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbZLIUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:07:34 -0500
Message-ID: <4B200306.7020603@zytor.com>
Date: Wed, 09 Dec 2009 12:05:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org> <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain> <4B1FFB59.2080404@goop.org>
In-Reply-To: <4B1FFB59.2080404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 11:32 AM, Jeremy Fitzhardinge wrote:
>   /*
>    * System calls that need a pt_regs pointer.
>    */
> -#define PTREGSCALL(name) \
> +#define PTREGSCALL_ARG(name,arg) \
>   	ALIGN; \
>   ptregs_##name: \
> -	leal 4(%esp),%eax; \
> +	leal 4(%esp),arg; \
>   	jmp sys_##name;
> -

I believe this will not work for the reason outlined in the other post.

	-hpa
