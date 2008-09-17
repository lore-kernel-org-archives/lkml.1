Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbYIQRIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbYIQRIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYIQRIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:08:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYIQRIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:08:38 -0400
Message-ID: <48D13960.2020902@zytor.com>
Date: Wed, 17 Sep 2008 10:07:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com> <20080917073058.GA3770@x200.localdomain> <20080917084754.GC24035@elte.hu>
In-Reply-To: <20080917084754.GC24035@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> the subsystem tags should be cut out by dmesg by default, just like the 
> normal <1> tags are cut out.
> 
[...]
> 
> and it's bad and a showstopper if the default output of 'dmesg' 
> degrades, like your noticed - those are bugs in the concept and need to 
> be fixed.
> 

It's probably worth pointing out that we had similar transition pains 
when we introduced the loglevel tags.  If you used an old dmesg/klogd 
you got the loglevel tags; we cleaned them up.

	-hpa
