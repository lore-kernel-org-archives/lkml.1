Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbXCGPah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbXCGPah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXCGPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:30:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:36272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbXCGPaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:30:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [patch] disable NMI watchdog by default
Date: Wed, 7 Mar 2007 15:56:49 +0100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070305122011.GA16133@elte.hu> <ada1wk1ycod.fsf@cisco.com>
In-Reply-To: <ada1wk1ycod.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703071556.49547.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 04:06, Roland Dreier wrote:
>  > --- linux.orig/include/asm-x86_64/nmi.h
>  > +++ linux/include/asm-x86_64/nmi.h
>  > @@ -63,7 +63,7 @@ extern int setup_nmi_watchdog(char *);
>  >  
>  >  extern atomic_t nmi_active;
>  >  extern unsigned int nmi_watchdog;
>  > -#define NMI_DEFAULT	-1
>  > +#define NMI_DEFAULT	0
> 
> Maybe I'm missing something obvious, but this patch doesn't seem
> correct to me.  The sentiment of disabling the NMI watchdog by default
> is fine, and I agree with it, but I don't think this patch does what
> it says.  First of all, I have a system running a kernel with this
> patch applied (v2.6.21-rc2-gc3442e2), and I see NMIs in
> /proc/interrupts and "testing NMI watchdog ... OK." in the log.

Yes the patch looks quite broken.

-Andi
