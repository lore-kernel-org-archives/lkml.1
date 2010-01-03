Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559Ab0ACKJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0ACKJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 05:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994Ab0ACKJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 05:09:42 -0500
Received: from 62.1.125.199.dsl.dyn.forthnet.gr ([62.1.125.199]:16691 "EHLO
	poseidon.vergina.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab0ACKJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 05:09:42 -0500
Message-ID: <4B406CDF.7010301@asyr.hopto.org>
Date: Sun, 03 Jan 2010 12:09:35 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091229 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>	<200912301208.54359.dirk.heinrichs@online.de>	<4B3B38F2.6090006@asyr.hopto.org>	<m3fx6r8a0l.fsf@intrepid.localdomain>	<4B3CF04E.8070603@asyr.hopto.org> <m3vdfmosha.fsf@intrepid.localdomain>
In-Reply-To: <m3vdfmosha.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 01/01/2010 03:38 PM Krzysztof Halasa wrote the following:
> Thanasis <thanasis@asyr.hopto.org> writes:
>
>   
>>> Depends on the "split" used. With 2 GB : 2 GB you can have all-lowmem
>>> 1.5 GB RAM, without CONFIG_HIGHMEM*. 2 GB of per-process address space
>>> is usually not a problem.
>>>       
>> How do you implement that? What do you mean 2GB:2GB split ?
>>     
> See "make menuconfig", Processor type and features -> Memory split. You
> need to select "EMBEDDED" and "EXPERIMENTAL" first. What you need for
> 1.5 GB RAM is VMSPLIT_2G.
>
> The idea is that the CPU address space is divided: ca. 2 GB (in this
> configuration) for user space (for each process - instead of 3 GB),
> 2 GB - 128 MB (or something like that, I don't remember exactly) for
> physical RAM, and the last 128 MB or so for PCI devices and other
> things.
>   
Hmm..., but are EMBEDDED options suitable for a netbook like the A110L ?
