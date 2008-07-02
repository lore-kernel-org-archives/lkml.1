Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYGBRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYGBRRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 13:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYGBRRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 13:17:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:28843 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYGBRRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 13:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FZXCQRESWrQLuEkq7zYd7lZQKdJJFcaq/bItUYpybHw10HHtNRncLB1hftdj39YXz/
         +shzMCPBDdwUamUAT9FvKRVv4JKc2pH8BLvvcwUK75Gjk91xoN/Isbzf5wGntVq29bLU
         XLad8jMXsNcrmue8ucAYfiuXscOkNmO4UHTTQ=
Date: Wed, 2 Jul 2008 21:16:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 6/7] x86: traps_xx: modify default_do_nmi
Message-ID: <20080702171637.GB7003@cvg>
References: <20080701193643.GA29695@mailshack.com> <20080701233227.GF29903@mailshack.com> <20080702161220.GA7003@cvg> <20080702163901.GA1283@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702163901.GA1283@mailshack.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Wed, Jul 02, 2008 at 06:39:01PM +0200]
|  - local caching of smp_processor_id() in default_do_nmi()
|  - v2: do not split default_do_nmi over two lines
| 
| Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| 
| ---
| 
| On Wed, Jul 02, 2008 at 08:12:20PM +0400, Cyrill Gorcunov wrote:
| > | -static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
| > | +static notrace __kprobes void
| > | +default_do_nmi(struct pt_regs *regs)
| > | [ ... ]
| > | -asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
| > | +asmlinkage notrace __kprobes void
| > | +default_do_nmi(struct pt_regs *regs)
| > 
| > Hi Alexander, good done, thanks! But why did you split default_do_nmi
| > definition by two lines? I think it would be better to keep them as it
| > was before, ie by a single line
| > 
| > 	static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
| 
| Thanks! Here is the replacement patch with default_do_nmi left on
| a single line. Patch 7 applies with 1 line fuzz.
| 
| Greetings,
|     Alexander
| 

Thanks, Alexander, this looks good to me. Feel free to add my
Signed-off if you need it.

		- Cyrill -
