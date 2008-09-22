Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYIVKPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYIVKPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYIVKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:15:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3614 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYIVKPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DtmGcQHTYfG8idiPTsOD2EIDVnrLTJh9HAwDYbBcYZP6UGDjMoe5kP2vjEszmI6jaa
         1v9xJ8tUnJXrW9yC2gXra+pUv5G7+D58gEVkTUkM7uGRgTYxEvTReSN8naLJ3/mlxiHz
         UiUYM7/XZwVEZWI4M0hykOFMAMcsli0ctr2B0=
Date: Mon, 22 Sep 2008 14:15:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: do_boot_cpu - add check if we have ESR register
Message-ID: <20080922101505.GF7663@localhost>
References: <20080922093603.GC7663@localhost> <20080922095148.GD7663@localhost> <86802c440809220257q4e1b4c81o534c957d919a6b3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809220257q4e1b4c81o534c957d919a6b3c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Mon, Sep 22, 2008 at 02:57:17AM -0700]
| >
| > Actually it's resend of the patch. On previous attempt
| > Yinghai was proposed to choose:
| >
| >> one apic_version or boot_cpu_apic_version could be enough
| >
| > but I think it should be different patch which does cleaning
| > up variables usage. So for now I think _this_ patch is enough
| > since idea is to prevent of touching nonexistant register rather
| > code cleaning (whci could be done later).
| 
| do we have systems that have mixed cpu supported with different apic version?
| 
| YH
| 

Yinghai what was the reason of this question? I've a suspicious
you're planning to test apic version early and only _once_ so
eliminating APIC_INTERGRATED call? Am I right?

		- Cyrill -
