Return-Path: <linux-kernel-owner+w=401wt.eu-S965752AbXCFCWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752AbXCFCWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965760AbXCFCWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:22:21 -0500
Received: from terminus.zytor.com ([192.83.249.54]:54018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965752AbXCFCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:22:19 -0500
Message-ID: <45ECD03F.2040008@zytor.com>
Date: Mon, 05 Mar 2007 18:21:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dmlb2000@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>	<20070305.160303.59493440.davem@davemloft.net>	<9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com> <20070305.162620.04006691.davem@davemloft.net>
In-Reply-To: <20070305.162620.04006691.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>>>
>> Thanks, but that still leaves PAGE_SIZE available for some
>> architectures and not for others shouldn't this be moved inside
>> __KERNEL__ in i386 and x86_64 then?
> 
> I definitely think so.

It definitely should, especially on x86-64, where the page size isn't 
guaranteed by the ABI (on i386, the ABI guarantees a 4K page size; on 
x86-64 it can be up to 64K.)

	-hpa
