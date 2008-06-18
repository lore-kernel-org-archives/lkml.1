Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYFRNIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYFRNIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYFRNIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:08:44 -0400
Received: from smtp.movial.fi ([62.236.91.34]:57919 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbYFRNIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:08:43 -0400
Message-ID: <48590926.5060009@movial.fi>
Date: Wed, 18 Jun 2008 16:09:58 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/math-emu/reg_constant
References: <20080614204452.25378bd0@paolo-desktop>
In-Reply-To: <20080614204452.25378bd0@paolo-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
>  
> -static void fld_const(FPU_REG const *c, int adj, u_char tag)
> +static void fld_const(FPU_REG const * c, int adj, u_char tag)
________________________________________^

The above does not seem to me like a big improvement in code quality. A
false positive from checkpatch.pl?

Dmitri

>  {
>  	FPU_REG *st_new_ptr;
>  

