Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXJYIqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXJYIqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXJYIqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:46:33 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:64569 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbXJYIqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:46:32 -0400
Date: Thu, 25 Oct 2007 01:46:15 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joshua.i.stone@intel.com,
       juan.villacis@intel.com
Subject: Re: [PATCH] IA64/perfmon: kill dead code, clean irq handling
Message-ID: <20071025084615.GA32656@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071023230908.GA12417@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023230908.GA12417@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

On Tue, Oct 23, 2007 at 07:09:08PM -0400, Jeff Garzik wrote:
> 
> By deleting unused code, this makes perfmon irq handling more efficient,
> as well as reducing code size.
> 
> * remove unused pfm_install_alt_pmu_interrupt()
> * remove unused pfm_remove_alt_pmu_interrupt()
> 
I have not problem with the patch except maybe for those two functions.
How do you know they are not used?
Have you checked the VTUNE open-source driver?
I thought at some point they were using this hook.


> * remove now-unused pfm_alt_intr_handler pointer, and associated
>   function call in perfmon interrupt handler.
> 
> * remove unused 'irq' argument from pfm_do_interrupt_handler()
> 
> * un-indent code in pfm_interrupt_handler() now that
>   pfm_alt_intr_handler is no longer used.
> 
--
-Stephane
