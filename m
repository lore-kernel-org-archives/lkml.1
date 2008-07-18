Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYGRRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYGRRua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbYGRRuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:50:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbYGRRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:50:09 -0400
Message-ID: <4880D7B9.8000007@zytor.com>
Date: Fri, 18 Jul 2008 10:49:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       jbarnes@virtuousgeek.org, Jack Howarth <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
References: <200807180941.09779.yhlu.kernel@gmail.com>	 <4880D684.7020406@zytor.com> <86802c440807181047y4ef2f227me72e6474e726596@mail.gmail.com>
In-Reply-To: <86802c440807181047y4ef2f227me72e6474e726596@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Jul 18, 2008 at 10:44 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>> change the mconf bus range from [0,0xff] to to [0, 0x3f]
>>> to match range [0xf0000000, 0xf4000000) in e820 tables.
>>>
>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>> Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
>> Why is this hard-coded instead of discovered dynamically?
> 
> you mean according to the range reserved in e820 to find out bus range
> that should be used for mmconf?

That would make sense, since you're truncating the mmconf range based on 
some arbitrary limit.  Even better would be to query the hardware 
register which is responsible for the truncation.

	-hpa
