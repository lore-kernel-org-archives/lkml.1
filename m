Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYH2VNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYH2VNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYH2VNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:13:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:19766 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbYH2VNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e4EjZr4zgWvdP7Vr+3Eooh+O/YWTEvrQ7B05HeMTMx+ASz+f8bI3QITWCsBlB7xxuO
         jIty8BBIg/kfVz7OmNOcaTJ7SsKRuZs6e8PERFD9n9iuoodSD5v4vaSY4BMHbLUUTLoD
         Gnu9vPFUumbeIMsYg+Vuk4RhqjtMx+r82q8Xg=
Message-ID: <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
Date: Fri, 29 Aug 2008 14:13:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <200808292157.24179.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808291913.26585.rjw@sisk.pl> <200808292157.24179.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 29 of August 2008, Rafael J. Wysocki wrote:
>> On Friday, 29 of August 2008, Linus Torvalds wrote:
>> >
>> > Another week (my weeks do seem to be eight days, don't they? Very odd),
>> > another -rc.
>> >
>> > The dirstat pretty much says it all:
>> >
>> >   43.0% arch/arm/configs/
>> >   43.9% arch/arm/
>> >   25.5% arch/powerpc/configs/
>> >   26.8% arch/powerpc/
>> >   73.9% arch/
>> >    4.4% drivers/usb/musb/
>> >    5.4% drivers/usb/
>> >    4.0% drivers/watchdog/
>> >   16.0% drivers/
>> >    3.5% fs/
>> >
>> > yeah, the bulk of it is all config updates, and with arm and powerpc
>> > leading the pack.
>>
>> Doesn't boot on my quad core test box, apparently because of an AHCI failure.
>>
>> Bisecting ...
>
> Bisection turned up commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd as the culprit:
>
> commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Mon Aug 25 00:56:08 2008 -0700
>
>    x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3
>
> Reverting this commit helps.
>

can i get whole bootlog with "debug"?

YH
