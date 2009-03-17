Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZCQC1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZCQC1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762510AbZCQC1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:27:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762361AbZCQC1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:27:20 -0400
Message-ID: <49BF0A51.5000909@kernel.org>
Date: Mon, 16 Mar 2009 19:26:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org> <49BEAD27.3050801@kernel.org> <49BEAFEC.7020400@goop.org> <49BEB5FE.7050601@zytor.com> <49BEBD98.3090905@goop.org> <49BEC143.6030104@zytor.com> <49BEC53F.20200@goop.org> <49BED431.5070201@zytor.com>
In-Reply-To: <49BED431.5070201@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> Or simplified:
>>>
>>> PAGE_TABLE_SIZE(((1 << 32)-PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
>>
>> Was worried about 1<<32 overflowing.  Never really sure what gas's
>> type system is.
>>
> 
> It's bignum-based.
> 
> You could also write:
> 
> PAGE_TABLE_SIZE((-PAGE_OFFSET & 0xffffffff) >> PAGE_SHIFT) << PAGE_SHIFT
> 
> (the & 0xffffffff is necessary, or you'll get a signed shift.)

max kernel address space range?

YH
