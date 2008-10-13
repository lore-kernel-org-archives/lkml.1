Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYJMSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYJMSvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYJMSvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:51:08 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:35603 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYJMSvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:51:07 -0400
Message-ID: <48F39A6C.3080809@numericable.fr>
Date: Mon, 13 Oct 2008 20:58:52 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008092811)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.27-git2] compilation warning for arch/x86/kernel/xsave.c
References: <48F1A789.3060707@numericable.fr> <20081013183940.GA7829@linux-os.sc.intel.com>
In-Reply-To: <20081013183940.GA7829@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Sun, Oct 12, 2008 at 12:30:17AM -0700, Rufus&  Azrael wrote:
>    
>> Hi Suresh,
>>
>>
>> Your commit ed405958057ca6a8c4c9178a7a3b1167fabb45f5 causes this
>> compilation warning on xsave.c :
>>
>>      
>>> arch/x86/kernel/xsave.c: In function ‘save_i387_xstate’:
>>> arch/x86/kernel/xsave.c:98: attention : ignoring return value of
>>> ‘__clear_user’, declared with attribute warn_unused_result
>>>        
>
> Thanks Rufus for the report and thanks Ingo for pushing the fix.
>
> I wonder why CONFIG_ENABLE_MUST_CHECK is not turned on by default?
> I turned this option on, in the list of configs I use.
>
> thanks,
> suresh
>
>    
Hi Suresh,


This option is set to Y in my .config, but I don't remember if it was 
volontary or by default.

Regards.

