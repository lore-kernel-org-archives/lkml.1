Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZKPPB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZKPPB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZKPPBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:01:55 -0500
Received: from ottmail.xandros.com ([142.46.212.35]:49746 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZKPPBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:01:53 -0500
X-Greylist: delayed 1728 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Nov 2009 10:01:53 EST
Date: Mon, 16 Nov 2009 09:33:05 -0500
From: Woody Suwalski <woodys@xandros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <4B0162A1.1080701@xandros.com>
In-Reply-To: <43e72e890911111426h3cd1e5bfya3fa6da810ce633e@mail.gmail.com>
References: <43e72e890911101527s6d29b35cuaf63e081762c1eb7@mail.gmail.com>
References: <43e72e890911111426h3cd1e5bfya3fa6da810ce633e@mail.gmail.com>
Subject: Re: Oops on i915 on 8086:a011 pine trail 2.6.32-rc6
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Tue, Nov 10, 2009 at 3:27 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>   
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
>>     
>
> I compiled my own 2.6.32-rc6 based Linus' tip from today actually and
> I didn't run into issues.
>
>   
I had similar problem on Pineview ( I think you have meant Pineview - 
not Pinetrail?)  - had to boot with "nomodeset" option.
However it has been rectified in a first git after -rc6.
Works for me now...

Woody

