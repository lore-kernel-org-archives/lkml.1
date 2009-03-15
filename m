Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZCOKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZCOKVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZCOKVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:21:01 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:10322 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947AbZCOKVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:21:00 -0400
Message-ID: <49BCD652.7060803@panasas.com>
Date: Sun, 15 Mar 2009 12:20:02 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rcx triviality - How to have foo.ko module with same name
 as foo.c source file
References: <49BCD2F6.6030903@panasas.com> <20090315101210.GA5669@uranus.ravnborg.org> <49BCD50B.4020501@panasas.com>
In-Reply-To: <49BCD50B.4020501@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2009 10:20:57.0795 (UTC) FILETIME=[BB2F5930:01C9A557]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> Sam Ravnborg wrote:
>> On Sun, Mar 15, 2009 at 12:05:42PM +0200, Boaz Harrosh wrote:
>>> Since sometime in the 2.6.29-rc I'm no longer able to produce an
>>> out-of-tree module that has the same base-name as a source file.
>>>
>>> This is what I had in 2.6.28:
>>> <Kbuild>
>>>     obj-m += foo.o
>>> </Kbuild>
>>> Where foo.c is a source file in the same directory.
>>>
>>> But since 2.6.29-rcx it will no longer build my foo.ko module. I
>>> had to change it to:
>>> <Kbuild>
>>>     foo_mod-y = foo.o
>>>     obj-m += foo_mod.o
>>> </Kbuild>
>>> Which changed my module name in scripts and packages.
>> We use the single .c file for a module with the same name as the
>> module all over the kernel.
>>
>> What is more likely is that your module started to include an
>> additional sourcefile (antoehr .o) in which case you no longer
>> can have a source file sharing the name of the module.
>>
>>> P.S:
>>>   Just asking I realized that I can just add an "mv ..." command to my make file.
>> Using mv is no-no..
>>
>> 	Sam
> 
> Hey hi, that was really fast ;) Thanks
> 
> I realize that in-tree it works for sure. It's when I use the "make -M ..." out-of-tree
> and... No, I changed nothing, I had this, one liner, one source, one module and all of a sudden
> it does not build. Let me check if it is a dependency problem (not rebuilding when things change)
> or does it not build at all. Checking ...
> 
> Boaz
> 

Sorry please disregard it works again, I was probably too quick to make assumptions.
I did an hard clean and every thing started to work again. I'm not sure what it was.

Sorry for the noise
Boaz

