Return-Path: <linux-kernel-owner+w=401wt.eu-S934635AbYBHHlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbYBHHlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYBHHlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:41:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893AbYBHHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:41:23 -0500
Message-ID: <47AC077F.1010809@zytor.com>
Date: Thu, 07 Feb 2008 23:40:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <47AB887E.7010000@zytor.com> <200802080006.54151.rjw@sisk.pl> <20080207233509.GB21468@elf.ucw.cz> <47AB975C.1010902@zytor.com> <20080208070419.GA4544@ucw.cz>
In-Reply-To: <20080208070419.GA4544@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> I really need the entry point to be at offset 0, so 
>>> that I can get
>>> pointers to my data. I could not figure out how to do 
>>> it any other
>>> way. And if 0 is taken, I thought I'd put header at the 
>>> end.
>>>
>> Why not just put the structure at 0, and put pointers in 
>> the structure to everything else you need?
> 
> segments:offsets rear its ugly head here. I need %ds to point to my
> data, and the way to do it is copy it from %cs; that needs start to be
> at 0.
> 
> If you can find a solution that does not need this (some
> segment/offset arithmetics at beggining of wakeup?) we could use it,
> but I was lost between relocations.
> 

Let me look at it in the morning.  Got a specific pointer?

	-hpa
