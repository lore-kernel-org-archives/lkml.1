Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbXEaMt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbXEaMt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbXEaMtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:49:49 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:12069 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbXEaMts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bE+z8wvHGYBHSoeB1IEilcn5l3b0k6Z4B1DVC/2aMFlPfIDy+GtZ2SITH0HYrDoZ8YDV2ZlzARJofWR81RNmWdD2P2oycsGeCtlK1hxaNlM5gSKVe+fa+Dsr1rtgfZegf+hSrdkAP76D0TqxPzHBnfW2DALJWDiRdsuwpoIiuzo=
Message-ID: <465EC464.7050302@gmail.com>
Date: Thu, 31 May 2007 08:49:40 -0400
From: Parag Warudkar <parag.warudkar@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of
 RAM on Intel 965WH motherboards. (FULL DMESG)
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com> <465E513E.60903@shaw.ca>
In-Reply-To: <465E513E.60903@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> I think that mem=8832M would work as well, to make the kernel use only 
> the memory that is marked cacheable. (It looks like this parameter 
> takes the highest memory address we want the kernel to use, not the 
> highest memory amount.)
>
Yep, and that would be much easier too.

I am curious though as this seems to be somewhat common a problem, could 
we make the kernel analyze which memory is not cacheable (it already 
knows this via MTRR) and not use that portion for anything? Plus may be 
warn the user to contact their BIOS vendor to correct the problem?

I think that would be possible - even if the kernel knows late that the 
memory was uncached we could migrate those pages in that region to 
someplace else?

Parag
