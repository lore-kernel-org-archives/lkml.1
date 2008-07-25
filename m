Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYGYSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYGYSyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYGYSyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:54:11 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62208 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916AbYGYSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:54:10 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=fVVHpIHWo-DTsCsL0RMA:9 a=BoiX-O4SB7XdSx7zASsA:7 a=-wCh8GUbplzI_yFPw2YLYuLd3gUA:4 a=5OxXCWZL5BMA:10 a=bwVuZ38C_bkA:10
Message-ID: <488A214C.3060605@shaw.ca>
Date: Fri, 25 Jul 2008 12:54:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
References: <fa.ajQey35b1AZPlS1/p6joOoTWhU4@ifi.uio.no>
In-Reply-To: <fa.ajQey35b1AZPlS1/p6joOoTWhU4@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Hello,
> 
> Found a few of these logged. See below.
> What are they? Harmfull? Bug?
> 
> Kind regards,
> Udo
> 
> Jul 20 18:39:03 testboard kernel: kswapd0: page allocation failure.
> order:2, mode:0x20

It's not really harmful, it just means the kernel was momentarily unable 
to allocate memory to handle an incoming network packet. That packet 
will get dropped, but the system should recover.

Not sure why it's allocating an order 2 chunk though, that is 16KB. Are 
you using jumbo frames on the network?
