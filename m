Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYG0Foz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYG0Foz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 01:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYG0Fos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 01:44:48 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2914 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYG0For (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 01:44:47 -0400
Message-ID: <488C0B41.9080905@xs4all.nl>
Date: Sun, 27 Jul 2008 07:44:33 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
References: <fa.D09/4X9DRMh7IIolk0FWx9V7A2k@ifi.uio.no> <fa.t1205kREOn3zo/ARD/J1XRupvUU@ifi.uio.no> <fa.JR0D/ya5niKzRp9PulS5LvnbhqQ@ifi.uio.no> <fa.ifMjE6bNVSEOY+bMgRSeQMCIhlI@ifi.uio.no> <488B8396.6000909@shaw.ca>
In-Reply-To: <488B8396.6000909@shaw.ca>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>> I can reproduce this by wget'ing a 5.xGB file from my MythTV box.
>> The receiving end is a Fedora 9, AMD x86_64 box with an Abit m56s-s3
>> board using nVidia Corporation MCP65 Ethernet (rev a3).
>> It uses the forcedeth: Reverse Engineered nForce ethernet driver.
>> Version 0.61.
>>
>> Should I forward this info to someone so this could be fixed?
>> Someone doing the kernel memory management?
>> Or forcedeth?
>> Or?
>>
>> Please let me know.
> 
> The fact you're using jumbo frames makes this more noticeable, since it
> needs a 9000 byte chunk of memory to receive the packet, which means
> that it needs to allocate a 16KB chunk of memory. This means that even
> if memory is not full, it can be that no sufficiently large chunk of
> memory is available.
> 
> Quite likely something could be done to improve this, yes..

What can/should I do?
I am not a programmer but can build kernels, apply patches, do testing, etc.

Kind regards,
Udo
