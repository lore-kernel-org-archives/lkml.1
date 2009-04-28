Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZD1Qia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZD1Qia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZD1QiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:38:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:32942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbZD1QiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:38:19 -0400
Message-ID: <49F7308A.2010804@kernel.org>
Date: Tue, 28 Apr 2009 09:36:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
References: <20090418192314.GA22107@suse.de> <20090418203718.GD30144@elte.hu> 	<49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org> 	<49F6B350.9080703@kernel.org> <ac3eb2510904280125w11a58388u6a51997e28609009@mail.gmail.com> 	<49F71EF6.3050102@kernel.org> <49F72205.7030306@kernel.org> 	<20090428153906.GA8896@suse.de> <49F7260F.8030405@kernel.org> <ac3eb2510904280856m1fc07002pc4fb630fd2946b62@mail.gmail.com>
In-Reply-To: <ac3eb2510904280856m1fc07002pc4fb630fd2946b62@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Apr 28, 2009 at 17:51, Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> before device_register==>device_initialize is called, kobj->ref is still 0.
>>
>> will get warn from
>>                if (!kobj->state_initialized)
> 
> Initialize the device before you do anything with it. And call _put()
> any time to get rid of ressources, which might have been allocated
> before registering.

need to replace device_register with device_add and call device_initialize before device_set_name?

YH
