Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYGMUsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYGMUsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYGMUsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:48:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:50028 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYGMUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bQoCgpFJQc+E+E5Q/Pyg7Q5EEEVrN32G42PDymp4QoAy5MY5N1TDxUhBWMkIK5wJz/
         YiBJfkk4YdjjLPlWO7ydPgccbttnwnwQJOcOFZv4/Od9IWMeey9BDnqKHimo8R4e0eBX
         g8AgptLvo6tRBUQP9j+N7HrS1CeMhTyaLhuh0=
Message-ID: <19f34abd0807131348s5e211ebdk1faa5c32ef04f1cf@mail.gmail.com>
Date: Sun, 13 Jul 2008 22:48:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <Pine.LNX.4.64.0807132122001.16625@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
	 <dd18b0c30807131234n5edf3e1dt93022a45d427b1fd@mail.gmail.com>
	 <19f34abd0807131252k5499e6e2sc93f8cd70f488b7e@mail.gmail.com>
	 <Pine.LNX.4.64.0807132122001.16625@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 10:27 PM, Hugh Dickins <hugh@veritas.com> wrote:
>> I didn't follow the discussion, but I may contribute the following information:
>>
>> This message first appears in my logs on May 16. That was with kernel
>> version 2.6.24.5-85.fc8. The kernel I used before that was
>> 2.6.24.4-64.fc8 (May 3). My logs go back to November 8
>> (2.6.23.1-42.fc8). So we can hardly consider this a regression since
>> 2.6.25, but rather one since 2.6.24?
>>
>> (I'll also note that this message appears quite infrequently here.
>> Only 42 times in 219 boot-ups. So it would be hard to bisect, but I'm
>> guessing the error was introduced somewhere between 2.6.24.4 and
>> 2.6.24.5.)
>
> You're comparing against Fedora kernels, which often contain
> patches which haven't got into mainline yet.  As in this case.
> Unless it used to be assembled from separate pieces, there was
> no "GPE storm detected" message in 2.6.24.N or 2.6.25.N: it was
> added in 2.6.26-rc1.
>
> I sometimes see it too, on a Fujitsu-Siemens laptop.

Oh, right. So what exactly is the bug here? That the message appears
at all? Or is there another specific change that would cause the
warning to trigger once added? Or why do we have bugzilla entries for
broken hardware? Is there anything I can do to help the situation as
the owner of a machine which exhibits the problem?

Thanks for the info :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
