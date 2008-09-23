Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYIWBcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYIWBcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYIWBcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:32:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:14452 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYIWBcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D4FfDgl6RP7Wb4uj9OTRHJho7f+uvMlRHsNtGIyelxPmKQbv/viW47TkDx2LwZ48em
         4I30G8vMR2wV9KmDQ5dhIWcEMhzA1eWxK2wTnxOhXIAc6tzHnTPO1zSiyMv8bGFC1JM6
         4C3vXYfev9bCzkPz6wEh2b1/uCm3+7Sk+aUVM=
Message-ID: <86802c440809221832p408d15aan9bdcd3aab54ed80d@mail.gmail.com>
Date: Mon, 22 Sep 2008 18:32:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Chris Li" <lkml@chrisli.org>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809221630s393bd003h230dd442aa386d6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <86802c440809191350h21327c76l55d2134d7667f5d0@mail.gmail.com>
	 <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
	 <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
	 <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
	 <86802c440809201435l6fdb7c90u59b6b816efb7f2f6@mail.gmail.com>
	 <70318cbf0809201504i3f9688b1u9692b4534af0627d@mail.gmail.com>
	 <86802c440809201522n5d450832vcbbd58d03a3943d8@mail.gmail.com>
	 <70318cbf0809201621r3f31466paef0586f094d40cf@mail.gmail.com>
	 <70318cbf0809221630s393bd003h230dd442aa386d6f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 4:30 PM, Chris Li <lkml@chrisli.org> wrote:
> On Sat, Sep 20, 2008 at 4:21 PM, Chris Li <lkml@chrisli.org> wrote:
>>> can you boot with pci=routeirq ?
>>
>> See attached dmesg.
>
> Ping?
>
> Any other suggestions? In the week end I try to patch the SATA driver
> and USB driver.
>
> I add some debug print from UHCI interrupt handler. So the interrupt
> start to hammer as soon as the first UHCI hook to IRQ 19. The UHCI
> status bit is clean.
>
> I also try to disable SATA interrupt at early PCI scan. It does not
> help either.
>
> So I guess seems like wrong irq routing. How do I find out which
> device is injecting the interrupt?
>

CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
