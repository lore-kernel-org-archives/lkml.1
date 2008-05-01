Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYEAMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYEAMmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYEAMmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:42:31 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17764 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754116AbYEAMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:42:30 -0400
Message-ID: <4819BAA6.9030105@panasas.com>
Date: Thu, 01 May 2008 15:42:14 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression	warnings
References: <1209593024.24729.119.camel@brick> <4819ACF6.9000403@panasas.com> <20080501120016.GV5882@ZenIV.linux.org.uk>
In-Reply-To: <20080501120016.GV5882@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2008 12:42:17.0436 (UTC) FILETIME=[CA1561C0:01C8AB88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01 2008 at 15:00 +0300, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, May 01, 2008 at 02:43:50PM +0300, Boaz Harrosh wrote:
> 
>> I don't know who invented sparse, but I like this form of return.
>> 1 - It saves me the curly brackets and extra return line. But mainly
>> 2 - It is a programing statement that says: "Me here I'm an equivalent 
>>   to that other call". So if in the future that inner function starts
>>   to return, say, an error value, with the first style the compiler will
>>   error. But with the second style the new error return will be silently
>>   ignored. So these are not equivalent replacements. The former is a much
>>   stronger bond between the caller and the callie.
> 
> 3.  6.8.6.4(1): A return statement with an expression shall not appear in
> a function whose return type is void.
> 

Please forgive my ignorance, where is this quote from?

> Write in C, please.

I have used this style for ages. I thought it is C, and the compiler never
complained. You must agree that the two statements are not equivalent. Is it
a bad style? I saw it's merits, perhaps it's just me.

Boaz
