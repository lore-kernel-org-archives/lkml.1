Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZI3P0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZI3P0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZI3P0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:26:02 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:52174 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZI3P0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rnFjvzrKcXkRufYPfG+UCXSJ1GXXk52Y7v/vLFapicwuiBL1TCov0JyZxJtkh0enA7
         rk0AyvsYivtr2XZ3AVNruMEv7tSPo/RQ8EZ8KoI1mTm36sZebkgrfMq6xOGaMA80lJbh
         e8cimvsRw2IpdemKLt3nRuBKw8tHedRIqB9QE=
Date: Wed, 30 Sep 2009 19:26:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add show_lapic=
Message-ID: <20090930152601.GB5235@lenovo>
References: <4ABF0DE0.1030400@kernel.org> <20090927080605.GA4984@lenovo> <4ABF2262.3090905@kernel.org> <20090927085406.GB4984@lenovo> <20090927102805.GC4984@lenovo> <20090927144008.GD4984@lenovo> <20090927174219.GA14280@lenovo> <20090928160757.GD5264@lenovo> <86802c440909281046o5fa0032do3497087d173cbf82@mail.gmail.com> <20090928180201.GH5264@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090928180201.GH5264@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Sep 28, 2009 at 10:02:01PM +0400]
| [Yinghai Lu - Mon, Sep 28, 2009 at 10:46:54AM -0700]
| | On Mon, Sep 28, 2009 at 9:07 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| ...
| | >
| | > -__apicdebuginit(int) print_all_ICs(void)
| | > +static int __initdata show_lapic = 1;
| | > +static __init int setup_show_lapic(char *arg)
| | > +{
| | > +       int num = -1;
| | > +
| | > +       if (strcmp(arg, "all") == 0) {
| | > +               show_lapic = CONFIG_NR_CPUS;
| | 
| | NR_CPUS or nr_cpu_ids?
| 
| NR_CPUS as far as I can tell -- maximal to not exit for() loop until end.
| nr_cpu_ids safe here as well, but constant is better :)
| 
| | 
| | YH
| | 
| 	-- Cyrill

Yinghai, any news here? I would like to know your conclusion
on this patch.

	-- Cyrill
