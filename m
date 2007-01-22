Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXAVUKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXAVUKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXAVUKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:10:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbXAVUKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:10:33 -0500
Message-ID: <45B518E4.5040104@redhat.com>
Date: Mon, 22 Jan 2007 15:04:52 -0500
From: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060803)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [-mm patch] drivers/firewire/: cleanups
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070122181736.GU9093@stusta.de> <45B51369.1060408@redhat.com> <20070122200423.GA9093@stusta.de>
In-Reply-To: <20070122200423.GA9093@stusta.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Jan 22, 2007 at 02:41:29PM -0500, Kristian Høgsberg wrote:
>> Adrian Bunk wrote:
>>> On Thu, Jan 11, 2007 at 10:26:27PM -0800, Andrew Morton wrote:
>>>> ...
>>>> Changes since 2.6.20-rc3-mm1:
>>>> ...
>>>> git-ieee1394.patch
>>>> ...
>>>> git trees
>>>> ...
>>>
>>> This patch contains the following cleanups:
>>> - "extern inline" -> "static inline"
>> I guess that's fine, I do like how extern inline will never generate code 
> 
> Exactly the opposite will be true when gcc will switch to the C99 
> semantics...
> 
> Besides this, "static inline" forces inlining in the kernel due to
>   #define inline          inline          __attribute__((always_inline))

In that case I have no reservations at all.

thanks,
Kristian

