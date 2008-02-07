Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbYBGWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbYBGWqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYBGWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:46:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbYBGWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:46:12 -0500
Message-ID: <47AB8A0F.9@zytor.com>
Date: Thu, 07 Feb 2008 14:45:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <20080207222845.GA6096@elf.ucw.cz> <200802072340.06138.rjw@sisk.pl>
In-Reply-To: <200802072340.06138.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

>  ENTRY(wakeup_long64)
>  wakeup_long64:
> -	movq    saved_magic, %rax
> -	movq    $0x123456789abcdef0, %rdx
> -	cmpq    %rdx, %rax
> -	jne     bogus_64_magic
> +	movq	saved_magic, %rax
> +	movq	$0x123456789abcdef0, %rdx
> +	cmpq	%rdx, %rax
> +	jne	bogus_64_magic

A random magic is probably more likely to be unique than something like 
that.

	-hpa
