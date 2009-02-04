Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZBDCPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZBDCPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZBDCPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:15:44 -0500
Received: from gw.goop.org ([64.81.55.164]:49570 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBDCPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:15:43 -0500
Message-ID: <4988FA4A.6080002@goop.org>
Date: Tue, 03 Feb 2009 18:15:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] xen: disable interrupts before saving in percpu
References: <4988DAEA.6040608@goop.org> <4988EE04.7090006@kernel.org>
In-Reply-To: <4988EE04.7090006@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> xen_mc_batch has a small preempt race where it takes the address of a
>> percpu variable immediately before disabling interrupts, thereby
>> leaving a small window in which we may migrate to another cpu and save
>> the flags in the wrong percpu variable.  Disable interrupts before
>> saving the old flags in a percpu.
>>     
>
> Applied to tip:core/xen, thanks!

Can you push this Linusward too?

Thanks,
    J
