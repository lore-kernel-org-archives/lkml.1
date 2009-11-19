Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZKSP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZKSP3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZKSP3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:29:33 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46272 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZKSP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:29:32 -0500
Message-ID: <4B056452.40108@canonical.com>
Date: Thu, 19 Nov 2009 09:29:22 -0600
From: Steve Conklin <steve.conklin@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       UBUNTU kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: Oops on i915 on 8086:a011 pine trail 2.6.32-rc6
References: <43e72e890911101527s6d29b35cuaf63e081762c1eb7@mail.gmail.com> <43e72e890911111426h3cd1e5bfya3fa6da810ce633e@mail.gmail.com>
In-Reply-To: <43e72e890911111426h3cd1e5bfya3fa6da810ce633e@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 04:26 PM, Luis R. Rodriguez wrote:
> On Tue, Nov 10, 2009 at 3:27 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> Getting an oops with a pine trail netbook I'm doing testing on on
>> 2.6.32-rc6 with a fresh new distro kernel for the next Ubuntu 10.04
>> release:
>>
>> https://launchpad.net/ubuntu/+source/linux/2.6.32-3.3/+build/1339939/+files/linux-image-2.6.32-3-386_2.6.32-3.3_i386.deb
>>
>> The machine boots fine with 2.6.31.
>>
>> The oops happens early on the boot process, I'll next rebuild my own
>> with early boot delay (CONFIG_BOOT_PRINTK_DELAY) as that seems to be
>> the only way I'm going to get this full trace out. Good thing is its
>> 100% reproducible so I should be able to bisect. The only thing
>> visible so far is the end of the oops:
>>
>> http://bombadil.infradead.org/~mcgrof/oops-img/2009/11/2.6.32-rc6-i915-8086-a011-oops-01.jpg
> 
> I compiled my own 2.6.32-rc6 based Linus' tip from today actually and
> I didn't run into issues.
> 
>   Luis

Luis (and everyone else),

I'm taking the lead for graphics on the Ubuntu kernel team. I'm happy to have bugs filed
on launchpad for these, and you can contact me directly or send email to the canonical
kernel team list, which I'm including in this distribution.

I'm tracking issues with a couple of platforms using the i915 driver as delivered
both in the karmic release, and in the 10.04 kernel. I hope to have them resolved soon.
Testing on the non-pinetrail platform this morning, the issues were resolved with the
patches queued for Linus's next merge. Knowing that Linus' tip solves your pine trail
issue is good information. Thanks for your testing work!

Steve Conklin
