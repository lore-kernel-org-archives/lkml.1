Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZFZHSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZFZHSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZFZHR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:17:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZFZHR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:17:57 -0400
Date: Fri, 26 Jun 2009 09:17:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 4/9] x86/boot: adding hw subarch ID for Moorestown
Message-ID: <20090626071755.GF14078@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E3@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E3@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pan, Jacob jun <jacob.jun.pan@intel.com> wrote:

> +++ b/arch/x86/include/asm/bootparam.h
> @@ -109,4 +109,9 @@ struct boot_params {
>  	__u8  _pad9[276];				/* 0xeec */
>  } __attribute__((packed));
>  
> +#define N_X86_SUBARCHS			4
> +#define X86_SUBARCH_PC			0
> +#define X86_SUBARCH_LGUEST 		1
> +#define X86_SUBARCH_XEN			2
> +#define X86_SUBARCH_MRST		3
>  #endif /* _ASM_X86_BOOTPARAM_H */

please use enums.

	Ingo
