Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYAJXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYAJXdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYAJXdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:33:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYAJXdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:33:07 -0500
Message-ID: <4786AB1B.4030004@zytor.com>
Date: Thu, 10 Jan 2008 15:32:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hwclock failure in x86.git
References: <4786AA11.5010805@gmail.com>
In-Reply-To: <4786AA11.5010805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> My first time building and booting the mm branch of x86.git was pretty
> successful.  The only error I noticed was the following in my dmesg:
> 
>  hwclock[622] general protection ip:804b226 sp:bff43e30 error:0
> 
> I'm not sure exactly how to debug this.  I could bisect, but there seems
> to be some useful debug information in there, so there might be
> something better to try first.
> 

That's a userspace IP; it implies the userspace hwclock binary did 
something bad, or the kernel didn't permit it to do something it should 
have.  The best thing to do would probably to strace hwclock and see 
what it did when it died.

	-hpa
