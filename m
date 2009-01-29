Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZA2GpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZA2GpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZA2GpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:45:09 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:36099 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZA2GpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:45:08 -0500
Date: Thu, 29 Jan 2009 15:44:54 +0900
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] xen: make sysfs files behave as their names suggest
Message-ID: <20090129064451.GA22245@verge.net.au>
References: <4980FD4C.3030700@goop.org> <20090129023516.GB1319@verge.net.au> <4981311D.9080205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4981311D.9080205@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 08:31:25PM -0800, Jeremy Fitzhardinge wrote:
> Simon Horman wrote:
>> On Wed, Jan 28, 2009 at 04:50:20PM -0800, Jeremy Fitzhardinge wrote:
>>   
>>> 1: make "target_kb" only accept and produce a memory size in kilobytes.
>>> 2: add a second "target" file which produces output in bytes, and will accept
>>>   memparse input (scaled bytes)
>>>
>>> This fixes the rather irritating problem that writing the same value
>>> read back into target_kb would end up shrinking the domain by a factor
>>> of 1024, with generally bad results.
>>>     
>>
>> Are there any compatibility issues that we should care about
>> related to this change?
>>   
>
> Well, in theory, but not in practice I think.
>
> It changes the behaviour of target_kb from accepting bytes into  
> kilobytes, and it no longer parses a k/m/g suffix.  The old behaviour  
> was a definite bug, given the name of the file, so I consider this to be  
> pure bugfix.  The kernel introducing this interface has only been out  
> for a week or two, so I don't think there's much chance anyone has  
> started relying on the buggy behaviour.

Thanks for the clarification. I have no objections.

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

