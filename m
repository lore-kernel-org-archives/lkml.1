Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0CEKJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:09:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51563 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0CEKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JSK1szOKFWdE0tDouw13+6b9l3yQeZC4HfC08EwoNOdHR/BTpWlojFNUkqQ0uhlrar
         xh55Kgz+XJC4PXCzpY7YGCEZCiCgy7NY1ReGFDzajOft6KZ1UgQI9C/rvgzNqU9eeTmC
         2f+ENN2TFuDEvM5XsvRYEHaXEdGEbo/TCUwIQ=
Message-ID: <4B90D848.5090801@gmail.com>
Date: Fri, 05 Mar 2010 11:09:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: no boot with NO_BOOTMEM=y [was: mmotm 2010-03-02-18-38 uploaded]
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <4B8FC98E.3070203@gmail.com> <4B8FCC4D.6040202@gmail.com> <4B905072.9080407@kernel.org>
In-Reply-To: <4B905072.9080407@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 01:29 AM, Yinghai Lu wrote:
> On 03/04/2010 07:05 AM, Jiri Slaby wrote:
>> Subject fixed.
>>
>> On 03/04/2010 03:54 PM, Jiri Slaby wrote:
>>> On 03/03/2010 03:39 AM, akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
>>>
>>> Hi, the kernel does not boot in qemu-kvm with NO_BOOTMEM=y. The last
>>> message is 'Booting the kernel.'
>>
> 
> tried with kvm/qemu with 512m and 8192m all works here...

Just for the record, I've just found out (thanks to 'mmotm boot panic
bootmem-avoid-dma32-zone-by-default.patch' thread), that when I revert
the patch, NO_BOOTMEM works...

-- 
js
