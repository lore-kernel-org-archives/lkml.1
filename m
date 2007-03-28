Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXC1Trt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXC1Trt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965721AbXC1Trt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:47:49 -0400
Received: from gw.goop.org ([64.81.55.164]:47451 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965694AbXC1Trs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:47:48 -0400
Message-ID: <460AC665.2090705@goop.org>
Date: Wed, 28 Mar 2007 12:47:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Add machine_ops interface  to abstract halting and rebooting
References: <46099709.2000304@goop.org> <200703282122.22869.ak@suse.de> <460AC2C6.9040406@goop.org> <200703282143.53037.ak@suse.de>
In-Reply-To: <200703282143.53037.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 28 March 2007 21:32, Jeremy Fitzhardinge wrote:
>   
>> machine_ops is an interface for the machine_* functions defined in
>> <linux/reboot.h>.  This is intended to allow hypervisors to intercept
>> the reboot process, but it could be used to implement other x86
>> subarchtecture reboots.
>>     
>
> Both patches added thanks
>   

I presume you've also got the reboot-fixups cleanup patch?

    J
