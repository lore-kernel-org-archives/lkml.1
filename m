Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYEBFFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYEBFFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYEBFFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:05:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYEBFFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:05:31 -0400
Message-ID: <481AA042.7060101@zytor.com>
Date: Thu, 01 May 2008 22:01:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why such a big difference in init-time PCI resource call-paths
 (x86 vs x86_64) ?
References: <fa.GFIas4KVpQq9pUpviRWeT8L+oBs@ifi.uio.no> <fa.hdrruKIvW+GZA0AESo+nBXNURSA@ifi.uio.no> <fa.9Qhgua9PuRzPYMHNs+ZG5Q7/Hbg@ifi.uio.no> <fa.sQSbKD/rf/mnDK28NkngvUl4UA8@ifi.uio.no> <481AA095.3010201@shaw.ca>
In-Reply-To: <481AA095.3010201@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>>
>> Yes, considering all possible reservation schemes is really critical 
>> here (including the magic knowledge of the legacy region).
> 
> FYI, from what I've read, Windows ignores e820 for detecting resource 
> reservations and looks at ACPI reservations only (at least if it's 
> running in ACPI mode which these days is almost universal). It seems 
> Windows really only uses e820 for locating RAM areas..

There is no doubt ACPI is critical.  Using E820 is good practice too, 
though.  Windows actually uses (only) one of several methods, depending 
on which HAL it chooses to use.

	-hpa
