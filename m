Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0BJTyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:54:22 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:54055 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0BJTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pWHjJO3FRoYBI4fwhmOMMWydpWPRIX+AOhMpJB6adK3ZfsDgS9wsaljBGBxHQC1TXL
         f9kzfn8vZ58AWM39b9fxkq9/GFHgjVMuoiBdIjBgH2ruaPgr9fDO2zx8GkqOmrjVGrXg
         UgLFw6gPmKbVudeq1T2Ym+1Op5FNiU0EtbSxk=
Message-ID: <4B730EE3.4080405@gmail.com>
Date: Wed, 10 Feb 2010 20:54:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@suse.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>	<4B50C2FA.4020100@gmail.com>	<4B50FC78.9010107@gmail.com> <20100122155237.e93a1c55.akpm@linux-foundation.org>
In-Reply-To: <20100122155237.e93a1c55.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2010 12:52 AM, Andrew Morton wrote:
> On Sat, 16 Jan 2010 00:38:32 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> (fixed subject)
>>
>> On 01/15/2010 08:33 PM, Jiri Slaby wrote:
>>> On 01/13/2010 09:17 PM, akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
>>>
>>> Hi, it crashes on my machine while booting up. It is a regression
>>> against 2010-01-06-14-34. Doesn't it ring a bell by a chance?
>>
>> Well, memcpying to something like this:
>> char *uevent_helper = CONFIG_UEVENT_HELPER_PATH;
>> doesn't sound like a good idea :).
>>
>> And it's racy with sysctl path anyway.
>>
>> Looks like added by:
>> sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch

Ping Andi.

-- 
js
