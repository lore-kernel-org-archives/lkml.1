Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXLLSHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXLLSHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXLLSG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:06:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbXLLSG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:06:56 -0500
Date: Wed, 12 Dec 2007 18:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 09/19] introduce fill_ldt
Message-ID: <20071212175651.GA18545@elte.hu>
References: <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com> <11974640872474-git-send-email-gcosta@redhat.com> <11974640932406-git-send-email-gcosta@redhat.com> <11974640983333-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11974640983333-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> diff --git a/include/asm-x86/ldt.h b/include/asm-x86/ldt.h
> index 20c5972..49013fd 100644
> --- a/include/asm-x86/ldt.h
> +++ b/include/asm-x86/ldt.h
> @@ -5,6 +5,7 @@
>   */
>  #ifndef _ASM_X86_LDT_H
>  #define _ASM_X86_LDT_H
> +#include <asm/desc_defs.h>

this breaks CONFIG_HEADERS_CHECK=y, because asm/desc_defs.h is not an 
exported header.

	Ingo
