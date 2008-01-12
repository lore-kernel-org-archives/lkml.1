Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYALV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYALV60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYALV6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:58:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYALV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:58:15 -0500
Message-ID: <478937EA.1010208@zytor.com>
Date: Sat, 12 Jan 2008 13:58:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Benjamin LaHaise <bcrl@kvack.org>, akpm@osdl.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: remove "too much work for irq" printk
References: <20080112201543.GB12775@kvack.org>	<20080112212457.3bf534af@lxorguk.ukuu.org.uk>	<47893374.4080102@zytor.com> <20080112214230.241018d4@lxorguk.ukuu.org.uk>
In-Reply-To: <20080112214230.241018d4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This is going to put trouble in other places unless, at least, it can be 
>> turned off.  The UART serial interface is heavily emulated as a console 
>> interface without an actual serial port behind it, both in hardware and 
>> software.  Rates will typically vastly exceed real serial port rates, 
> 
> Yes Dell do it, HP do it, IBM do it. Have done for years, never caused us
> a problem. Its only KVM tripping it.
> 
> As to bit rate we support up to about 1 to 1.5 Mbit.
> 

FWIW, the highest rate I've seen in hardware is a FIFO about 4K deep 
that can be polled at about 25 MHz when all the overhead is accounted for.

	-hpa
