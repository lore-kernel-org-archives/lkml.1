Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXEQWOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXEQWOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXEQWOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:14:30 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbXEQWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:14:29 -0400
Message-ID: <464CD3BB.3090604@zytor.com>
Date: Thu, 17 May 2007 15:14:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Dave Jones <davej@redhat.com>, Christian <haveaniceday@cv-sv.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705171351.34531.ak@suse.de>
In-Reply-To: <200705171351.34531.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>
>> The C3s all have cx8, but it needs to be enabled in an MSR first.
>> (See arch/i386/kernel/cpu/centaur.c , search for CX8)
> 
> Sigh. I wonder what genius at VIA came up with that setup.
> 

It's very simple, actually.  We had to do something similar at
Transmeta, because Windows NT 4 was very fond of assuming that certain
features meant certain *other* features were enabled, or would just
plain crash if it saw a combination that confused it.

	-hpa
