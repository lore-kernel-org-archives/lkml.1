Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYGXPrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYGXPrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYGXPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:47:31 -0400
Received: from gw.goop.org ([64.81.55.164]:44087 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYGXPrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:47:31 -0400
Message-ID: <4888A410.3020108@goop.org>
Date: Thu, 24 Jul 2008 08:47:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: call early_cpu_init at the same point
References: <488520A2.1080701@goop.org> <20080724102856.GB28817@elte.hu>
In-Reply-To: <20080724102856.GB28817@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Call early_cpu_init() at the same (early) point in setup_arch(). The 
>> x86_64 code was calling it relatively late, after when other arch code 
>> need to do cpu-related setup which depends on it.
>>     
>
> applied to tip/x86/urgent, thanks Jeremy.
>   

Thanks.  Curious to see if this causes any breakage, especially in 
numa-ish type systems.

    J
