Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbXFQJmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbXFQJmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbXFQJlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:41:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:1216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbXFQJly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=H/2pUgm/PV7sgykxNrQspgo317bgPoUewYXK89B3pSrk1pvQV+O1Sy21x54JvSivGLn/9tdZ5B6P/ubNw6sIOJ3insHG7RLLqVcTS3ib3fWlaXvZ8GCxA12Ka61dcSxt4See2rsZ62zxh6zHzoHw3k3fcKg+4qQpk7q4gL7u0rw=
Message-ID: <467501D0.3090203@googlemail.com>
Date: Sun, 17 Jun 2007 11:41:36 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH]  (Re: regression tracking (Re: Linux 2.6.21))
References: <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>
In-Reply-To: <20070617004436.GU3588@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Adrian Bunk pisze:
> On Sat, Jun 16, 2007 at 02:23:25PM +0200, Stefan Richter wrote:
>> ...
>> [Adrian, I'm not saying "too few users run -rc kernels", I'm saying "too
>> few FireWire driver users run -rc kernels".]
> 
> Getting more people testing -rc kernels might be possible, and I don't 
> think it would be too hard. And not only FireWire would benefit from 
> this, remember e.g. that at least 2 out of the last 5 kernels Linus 
> released contained filesystem corruption regressions.
> 
> The problem is that we aren't able to handle the many regression reports 
> we get today, so asking for more testing and regression reports today 
> would attack it at the wrong part of the chain.
> 
> Additionally, every reported and unhandled regression will frustrate the 
> reporter - never forget that we have _many_ unhandled bug reports 
> (including but not limited to regression reports) where the submitter 
> spent much time and energy in writing a good bug report.
> 
> If we somehow gain the missing manpower for debugging regressions we can 
> actively ask for more testing. Missing manpower (of people knowing some 
> part of the kernel well) for debugging bug reports is IMHO the one big 
> source of quality problems in the Linux kernel. If we get this solved, 
> things like getting more testers for -rc kernels will become low hanging 
> fruits.

Adrian, I agree with _all_ your points.

I bet that developers will hate me for this.

Please consider for 2.6.23

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/Documentation/SubmitChecklist	2007-06-17 11:18:37.000000000 +0200
+++ linux-work/Documentation/SubmitChecklist	2007-06-17 11:29:26.000000000 +0200
@@ -90,3 +90,8 @@ kernel patches.
     patch style checker prior to submission (scripts/checkpatch.pl).
     You should be able to justify all violations that remain in
     your patch.
+
+
+
+If the patch introduces a new regression and this regression was not fixed
+in seven days, then the patch will be reverted.
