Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYEDJEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYEDJEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYEDJD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:03:57 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:44779 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYEDJD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:03:56 -0400
Message-ID: <481D7BF8.4080405@numericable.fr>
Date: Sun, 04 May 2008 11:03:52 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu>
In-Reply-To: <20080504085204.GE21859@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Rufus & Azrael <rufus-azrael@numericable.fr> wrote:
>
>   
>> When upgrading to 2.6.25-git18 and above kernel this Xorg error occurs :
>>
>> xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Invalid 
>> argument)
>>
>> The latest working kernel was 25-git17 and perhaps is it related to 
>> http://lkml.org/lkml/2008/4/28/52
>>     
>
> does this X-does-not-start-up problem go away if you disable this 
> option:
>
>   
>> CONFIG_X86_PAT=y
>>     
>
> ?
>
> 	Ingo
>
>   
Thanks for your help Ingo, all work fine when CONFIG_PAT=n :-)

