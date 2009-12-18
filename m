Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbZLRATM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbZLRATM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZLRATJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:19:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZLRATH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:19:07 -0500
Message-ID: <4B2ACA46.90707@redhat.com>
Date: Thu, 17 Dec 2009 19:18:14 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk
References: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org> <tip-8c63450718ea62ee3a70bffde170b4d15fc72d3c@git.kernel.org> <4B2AC710.2090705@redhat.com> <4B2AC7C0.6040801@zytor.com>
In-Reply-To: <4B2AC7C0.6040801@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/17/2009 04:04 PM, Masami Hiramatsu wrote:
>>>
>>> Warning: objdump version  is older than 2.19
>>> Warning: Skipping posttest.
>>>
>>> because it used the wrong field from `objdump -v':
>>>
>>> akpm:/usr/src/25> /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-objdump -v
>>> GNU objdump 2.16.1
>>> Copyright 2005 Free Software Foundation, Inc.
>>> This program is free software; you may redistribute it under the terms of
>>> the GNU General Public License.  This program has absolutely no warranty.
>>
>>
>> Oh, I didn't know that.
>> On my environment, objdump shows version in below format.
>> ---
>> $ objdump -v
>> GNU objdump version 2.19.51.0.14-1.fc11 20090722
>> Copyright 2008 Free Software Foundation, Inc.
>> This program is free software; you may redistribute it under the terms of
>> the GNU General Public License version 3 or (at your option) any later version.
>> This program has absolutely no warranty.
>> ---
>>
>> Hmm, maybe, we need to check if ($3 == "version") to decide
>> which argument we should use.
>>
> 
> How about looking for the first argument that starts with a number?

Sure, that's also possible. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

