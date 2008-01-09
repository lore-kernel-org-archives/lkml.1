Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbYAIKa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbYAIKa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYAIKaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:30:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:33156 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYAIKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:30:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AtWvHuC40M0C/baD1f/yftUNjuRerp1VoFV6wOYz/KU0lvfVQcrrYTqVIrd6ltcz+4O0ZvMvI1Bc7HX55/wHKvXHkRVDo6gjejdLLG+IvkQsUrYB2yPlEGP9Cjj8X6guDYN4/3vP8JtNJr0LpQFLfY8itjbwv/43dQ6Ypoo2ZmY=
Message-ID: <4784A230.8080906@gmail.com>
Date: Wed, 09 Jan 2008 11:30:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Dmitry Torokhov <dtor@mail.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org
Subject: Re: evdev soft lockup 2.6.24-rc5-mm1
References: <47848CF5.8000107@gmail.com> <Pine.LNX.4.64.0801091107200.25041@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0801091107200.25041@twin.jikos.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2008 11:11 AM, Jiri Kosina wrote:
> On Wed, 9 Jan 2008, Jiri Slaby wrote:
> 
>> BUG: soft lockup - CPU#1 stuck for 11s! [X:2887]
> [ ... ]
>> Call Trace:
>>  [<ffffffff804e7648>] __mutex_lock_slowpath+0x38/0xd0
>>  [<ffffffff804e747e>] mutex_lock+0x1e/0x30
>>  [<ffffffff8040c497>] input_release_device+0x27/0x50
>>  [<ffffffff804102aa>] evdev_ungrab+0x3a/0x50
>>  [<ffffffff804103eb>] evdev_release+0xcb/0xd0
>>  [<ffffffff80293460>] __fput+0xc0/0x230
>>  [<ffffffff802938a6>] fput+0x16/0x20
>>  [<ffffffff80290296>] filp_close+0x56/0x90
>>  [<ffffffff80291afa>] sys_close+0x9a/0xf0
>>  [<ffffffff8020ba4e>] system_call+0x7e/0x83
>> I was not able to use sysrq keys, the keyboard is obviously defunct. If 
>> this is not known, I'll try to turn lockdep on and maybe connect through 
>> ssh next time it happens.
> 
> Is this reproducible on your side? 

not 100%, it happens occasionally.

> Running with lockdep would be really helpful, so that we possibly know who 
> is holding the other instance of dev->mutex.

I'll try my best.
