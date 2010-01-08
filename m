Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487Ab0AHAoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0AHAoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080Ab0AHAoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:44:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0AHAoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:44:18 -0500
Message-ID: <4B467FCB.2080101@zytor.com>
Date: Thu, 07 Jan 2010 16:43:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Michal Marek <mmarek@sues.cz>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] Makefile: Unexport LANG
References: <20091224111300.GA31932@verge.net.au> <4B359166.3050106@redhat.com> <4B359BC0.3080808@zytor.com> <20091226112007.GB2818@verge.net.au> <20100108004117.GK2436@verge.net.au>
In-Reply-To: <20100108004117.GK2436@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 04:41 PM, Simon Horman wrote:
> On Sat, Dec 26, 2009 at 10:20:07PM +1100, Simon Horman wrote:
>> On Fri, Dec 25, 2009 at 09:14:40PM -0800, H. Peter Anvin wrote:
>>> On 12/25/2009 08:30 PM, Masami Hiramatsu wrote:
>>>>>  
>>>>>  # Avoid funny character set dependencies
>>>>> +unexport LANG
>>>>>  unexport LC_ALL
>>>>>  LC_CTYPE=C
>>>>>  LC_COLLATE=C
>>>>
>>>
>>> At this point, it seems to me that we should just LC_ALL=C and be done
>>> with it (see other thread.)
>>
>> Sure, that would also work for the case that I'm seeing.
>>
>> I tested the following:
>>
>> # Avoid funny character set dependencies
>> LC_ALL=C
>> export LC_ALL
>>
>> Though personally I would advocate tweaking the locale as needed closer
>> to awk scripts and the like, rather than the high-level general change that
>> was made. Fall-out from a high-level change seems inevitable to me.
> 
> This seems to still be broken. Can we decide on a solution?
> 

I think it's up to Michal to pick the preferred solution.

It has been pointed out that one option might also to be to *not*
override LC_CTYPE, and only override LC_COLLATE.

	-hpa


