Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXGIMOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXGIMOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXGIMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:14:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:34369 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXGIMO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:14:28 -0400
Message-ID: <469226AA.6010801@qumranet.com>
Date: Mon, 09 Jul 2007 15:14:34 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Sasa Ostrouska <casaxa@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: KVM-AMD OOPS
References: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com>	 <4691BF62.2060207@goop.org> <4691DEE3.5050305@argo.co.il>	 <469223F1.8000904@qumranet.com> <dcf706c60707090510w4a1293cbw69c8e0d47640f77d@mail.gmail.com>
In-Reply-To: <dcf706c60707090510w4a1293cbw69c8e0d47640f77d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sasa Ostrouska wrote:
> On 7/9/07, Avi Kivity <avi@qumranet.com> wrote:
>>
>> Please post your .config.
>>
>
> Here is my config:
>
[config config config]

> #
> # Virtualization
> #
> CONFIG_KVM=y
> CONFIG_KVM_INTEL=m
> CONFIG_KVM_AMD=m

Ah, kvm is built in but the arch modules aren't.

Anybody know how to disallow A to be a module if B is builtin?

Or maybe I should just make that code a static inline.

-- 
error compiling committee.c: too many arguments to function

