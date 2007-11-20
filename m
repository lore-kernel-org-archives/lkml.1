Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbXKTCVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbXKTCVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760377AbXKTCUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:20:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbXKTCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:20:15 -0500
Message-ID: <47424435.8050704@zytor.com>
Date: Mon, 19 Nov 2007 18:19:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: clameter@sgi.com, ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
References: <20071120011132.143632442@sgi.com>	<20071120011340.569486037@sgi.com>	<47423FB7.20800@zytor.com> <20071119.181720.03409715.davem@davemloft.net>
In-Reply-To: <20071119.181720.03409715.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>> There was, at some point, discussion about using the gcc TLS mechanism, 
>> which should permit even better code to be generated.  Unfortunately, it 
>> would require gcc to be able to reference %gs instead of %fs (and vice 
>> versa for i386), which I don't think is available in anything except 
>> maybe the most cutting-edge version of gcc.
> 
> You can't use __thread because GCC will cache __thread computed
> addresses across context switches and cpu changes.
> 
> It's been tried before on powerpc, it doesn't work.

OK, that pretty much answers that question.

	-hpa
