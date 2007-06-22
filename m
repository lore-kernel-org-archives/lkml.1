Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXFVBqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXFVBqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXFVBqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:46:24 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbXFVBqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:46:23 -0400
Message-ID: <467B29DA.9040309@zytor.com>
Date: Thu, 21 Jun 2007 18:46:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Bart Trojanowski <bart@jukie.net>, linux-kernel@vger.kernel.org
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
References: <20070419141804.GO32620@jukie.net> <46290DED.80500@gmail.com>
In-Reply-To: <46290DED.80500@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 04/19/2007 04:18 PM, Bart Trojanowski wrote:
> 
>> I need to preserve some state from the bios before entering protected
>> mode.  For now I want to copy it into some ram accessible by
>> real-mode, say the last megabyte visible in real-mode.
>>
>> What's the easiest way to have linux ignore the megabyte starting at 15M?
> 
> Note that real-mode can only access the first megabyte (*) and not the
> first 16. 16MB is the 16-bit protected mode (286) limit.
> 

No, 16-bit protected mode (on 386+) is not limited to 16 MB.

The main reason there is a 16 MB limit in some current systems is that
ISA, and the ISA DMA controller only had 24 address lines.

	-hpa
