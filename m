Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYGRDqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYGRDqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 23:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYGRDqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 23:46:36 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:39120 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYGRDqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 23:46:36 -0400
Message-ID: <488011FF.6010201@nortel.com>
Date: Thu, 17 Jul 2008 21:46:07 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Reg Clemens <reg@dwf.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Does 2.6.26 provide nanosecond time to the user?
References: <200807180019.m6I0J2kG026240@deneb.dwf.com>
In-Reply-To: <200807180019.m6I0J2kG026240@deneb.dwf.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2008 03:46:11.0115 (UTC) FILETIME=[D1AECFB0:01C8E888]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reg Clemens wrote:
> Im confused.
> (sorry I havent been following the linux-kernel mailing list on this)
> 
> Does 2.6.26 use nanosecond time
>     (1) internally?
>     (2) provide it to the user?

It's available to userspace via clock_gettime(), but whether it really 
is accurate to sub-microseconds will depend on the specific version of 
the kernel and hardware architecture being used.

Chris
