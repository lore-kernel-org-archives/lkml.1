Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbYGORfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbYGORfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYGORe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:34:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbYGORe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:34:57 -0400
Date: Tue, 15 Jul 2008 10:34:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] stackprotector updates for v2.6.27
In-Reply-To: <20080714145625.GA23501@elte.hu>
Message-ID: <alpine.LFD.1.10.0807151033250.3017@woody.linux-foundation.org>
References: <20080714145625.GA23501@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index acc0271..b98e995 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -114,6 +114,7 @@ config DIRECT_GBPAGES
>  config DEBUG_RODATA_TEST
>  	bool "Testcase for the DEBUG_RODATA feature"
>  	depends on DEBUG_RODATA
> +	default y
>  	help
>  	  This option enables a testcase for the DEBUG_RODATA
>  	  feature as well as for the change_page_attr() infrastructure.

DAMMIT!

Ok, I'm just going to refuse to pull since for once I noticed this in 
time.

			Linus
