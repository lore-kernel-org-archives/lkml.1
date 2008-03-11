Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbYCKR0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbYCKR0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYCKR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:26:33 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:64713 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYCKR0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:26:32 -0400
Message-ID: <47D6C0A8.6010504@nortel.com>
Date: Tue, 11 Mar 2008 11:26:00 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803110414.40954.phillips@phunq.net> <20080311112329.GR1581@marowsky-bree.de> <200803110450.19390.phillips@phunq.net>
In-Reply-To: <200803110450.19390.phillips@phunq.net>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2008 17:26:03.0984 (UTC) FILETIME=[FBA12D00:01C8839C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Tuesday 11 March 2008 04:23, Lars Marowsky-Bree wrote:
> 
>>If I always assume a reliable shutdown - UPS protected, no crashes, etc
>>- you're right, but at least my real world has other failure scenarios
>>as well. In fact, the most common reason for unorderly shutdowns are
>>kernel crashes, not power failures in my experience.
> 
> 
> What are you doing to your kernel?

<snip>

> Honestly, I have never seen a machine running
> Linux 2.6 crash due to a software flaw, except when I caused it
> myself.  I suspect the Linux kernel has a better MTBF than a hard
> disk.

I have experienced many 2.6 crashes due to software flaws.  Hung 
processes leading to watchdog timeouts, bad kernel pointers, kernel 
deadlock, etc.

When designing for reliable embedded systems it's not enough to handwave 
away the possibility of software flaws.

Chris

