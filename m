Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbYGJS73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbYGJS73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYGJS7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:59:19 -0400
Received: from gw.goop.org ([64.81.55.164]:58682 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYGJS7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:59:18 -0400
Message-ID: <48765BF8.1070401@goop.org>
Date: Thu, 10 Jul 2008 11:59:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, akataria@vmware.com,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com> <20080709061336.GG9760@elte.hu> <86802c440807090020q516b6332qf8e0d65918e7001e@mail.gmail.com> <1215624603.3930.8.camel@alok-dev1> <86802c440807091038m6c14f165xede8b2b0316d0225@mail.gmail.com> <20080710072201.GE14377@elte.hu> <86802c440807100034w3a3ee192k8e565b75fd2df608@mail.gmail.com> <20080710075030.GA27361@elte.hu> <86802c440807100104s1e1f1cdeg421be2dbeffdcb75@mail.gmail.com> <20080710081206.GA4819@elte.hu>
In-Reply-To: <20080710081206.GA4819@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> then my guess would be on:
>
>  89d7bb5: x86_64: add workaround for no %gs-based percpu
>   

I'd be surprised.  That patch just moves some code around, and adds a 
couple of macros that only Xen uses.

    J
