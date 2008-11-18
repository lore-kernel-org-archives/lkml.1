Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYKRASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYKRASk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKRASb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:18:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYKRASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:18:30 -0500
Message-ID: <492209C8.7040602@zytor.com>
Date: Mon, 17 Nov 2008 16:18:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
References: <20081118001137.GA12350@linux-os.sc.intel.com> <492208BE.2000001@zytor.com> <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
> All C-states higher than C1. 
> 

Including C2?  If so, the TSC is unusable since C2 can be invoked 
asynchronously by the chipset.

	-hpa

