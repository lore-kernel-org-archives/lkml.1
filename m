Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYFPWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYFPWrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYFPWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:47:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbYFPWrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:47:36 -0400
Message-ID: <4856ECC0.3050201@kernel.org>
Date: Mon, 16 Jun 2008 15:44:16 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make asm/asm.h work for asm code.
References: <4856E3D3.2010207@goop.org>
In-Reply-To: <4856E3D3.2010207@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> +# define __ASM_INC    incl
> +# define __ASM_INC    incq
> +#define _ASM_INC    __ASM_INC
> +#define _ASM_INC    " " __stringify(__ASM_INC) " "

You have *exactly* as many #defines as if one would simply do four cases 
(32 C, 64 C, 32 asm, 64 asm), and that would be easier to read...

	-hpa
