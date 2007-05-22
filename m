Return-Path: <linux-kernel-owner+w=401wt.eu-S1764329AbXEVIT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764329AbXEVIT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXEVITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:19:47 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:54796 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbXEVITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:19:47 -0400
Message-ID: <4652A77B.6020306@free.fr>
Date: Tue, 22 May 2007 10:19:07 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
References: <464DC019.6010008@free.fr> <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr> <20070518204650.GA17343@uranus.ravnborg.org>
In-Reply-To: <20070518204650.GA17343@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, May 18, 2007 at 10:27:06PM +0200, Jan Engelhardt wrote:
>> On May 18 2007 17:02, John Sigler wrote:
>>> I'm getting "disagrees about version of symbol struct_module" messages,
>>> and I'm trying to understand why.
>>>
>>> As far as I understand (which is not very far), if I define
>>> CONFIG_MODVERSIONS, then checksums for various functions (all exported
>>> functions?) and various structures (which ones?) will be included inside
>>> the kernel image, and written to Module.symvers. When an out-of-tree
>>> module is built, it will also include these checksums.
>>>
>>> How do I list the checksums within a module?
>>>
>>> Is there a simpler way to list all the checksums?
>> 22:25 ichi:~ > modinfo aes
>> srcversion:     8CB82B3A254D5A950FD0D14
>>
>> I think this one checksum is computed out of all functions that
>> the module uses.
>
> It is computed based on all files used for the module.
> Check help for "Loadable module support | Source Checksum for all modules"

How do I list *all* the checksums inside a given module?

For example, I want to know the checksum for "struct_module" in test.ko

$ grep struct_module Module.symvers
0x71d1e11f      struct_module   vmlinux EXPORT_SYMBOL

That's for the kernel.

$(MAGIC_COMMAND_TO_DUMP_CHECKSUMS) test.ko | grep struct_module
=> ...

Regards.
