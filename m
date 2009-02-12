Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbZBLMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbZBLMzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbZBLMzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:55:44 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:4331 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755967AbZBLMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:55:43 -0500
Message-ID: <49941C4A.4050401@panasas.com>
Date: Thu, 12 Feb 2009 14:55:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: get/put unaligned helpers
References: <20090211143521.GA18866@lst.de> <1234367339.5481.3.camel@brick> <4993E2CA.1070408@panasas.com> <alpine.LFD.1.10.0902121241570.7279@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0902121241570.7279@ftp.linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2009 12:55:41.0311 (UTC) FILETIME=[35C938F0:01C98D11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Thu, 12 Feb 2009, Boaz Harrosh wrote:
> 
>> Speaking of which. When all this is done do you intend to also export
>> the unaligned.h headers to user-mode just like the aligned Endian helpers?
>>
>> That could help in a couple of projects, so you have my vote.
> 
>  Why would you need that?  GCC provides a portable, platform-independent 
> way.  It has had it for ten years at the very least.
> 

Do you mean the __built_in_swabXX() and all these guys.

I was under the impression they need to be aligned because otherwise that means
something is done wrong. Because the aligned version on lots of CPUs is one instruction
where unaligned access is better, or must, be emulated (byte accessed).

Assembly wise the two accesses are different and sometimes the compiler has no way to
know, where the programmer can know for sure.

But I like to be educated any day, please explain what to use when.

>   Maciej

Thanks
Boaz
