Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYIVTVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYIVTVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIVTVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:21:31 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:12854 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYIVTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vJV9yAQkSLhBPFQumQEnHHU4n8klcUo2l+W0Urekb3QHl5GTHcUGXvtT9PzuTLmXvD
         ipyhrUCYi/4DFG5eDPPSP4k8IYulhr2zuND2Fl88wpi6XiQEIRWeXFX66NuLJeuo2FXJ
         izrEFMIBCQcc3LfFwib1IJbL58P5FIQM/aiig=
Date: Mon, 22 Sep 2008 23:21:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: do_boot_cpu - add check if we have ESR register
Message-ID: <20080922192134.GD22024@localhost>
References: <20080922093603.GC7663@localhost> <20080922095148.GD7663@localhost> <86802c440809220257q4e1b4c81o534c957d919a6b3c@mail.gmail.com> <20080922101505.GF7663@localhost> <86802c440809221137v63e46951j78ae337275872b58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809221137v63e46951j78ae337275872b58@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Mon, Sep 22, 2008 at 11:37:21AM -0700]
| On Mon, Sep 22, 2008 at 3:15 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Yinghai Lu - Mon, Sep 22, 2008 at 02:57:17AM -0700]
| > | >
| > | > Actually it's resend of the patch. On previous attempt
| > | > Yinghai was proposed to choose:
| > | >
| > | >> one apic_version or boot_cpu_apic_version could be enough
| > | >
| > | > but I think it should be different patch which does cleaning
| > | > up variables usage. So for now I think _this_ patch is enough
| > | > since idea is to prevent of touching nonexistant register rather
| > | > code cleaning (whci could be done later).
| > |
| > | do we have systems that have mixed cpu supported with different apic version?
| > |
| > | YH
| > |
| >
| > Yinghai what was the reason of this question? I've a suspicious
| > you're planning to test apic version early and only _once_ so
| > eliminating APIC_INTERGRATED call? Am I right?
| 
| want to put more thing in genapic...
| 
| YH
| 

I think Ingo could drop this patch then at all.

		- Cyrill -
