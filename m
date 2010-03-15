Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0COECG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 00:02:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44959 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab0COECD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 00:02:03 -0400
Message-ID: <4B9DB0F2.7060808@zytor.com>
Date: Sun, 14 Mar 2010 21:00:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com> <4B9D8BB2.1010507@zytor.com> <201003150326.22262.vda.linux@googlemail.com>
In-Reply-To: <201003150326.22262.vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2010 07:26 PM, Denys Vlasenko wrote:
>>
>> Yes, but it does squat for a flash disk that wants, say, 256K alignment.
> 
> 4K makes sense. 256K not so much.
> 
> 256K alignment is hard to swallow for a lot of reasons anyway.
> Unless the filesystem packs small files into blocks a-la reiserfs,
> 256K block filesystems will be very inefficient for a typical
> storage scenarios.
> 

Noone has talked about using 256K filesystem blocks.  The fact of the
matter, though, is that both flash and RAID have much larger alignment
requirements than a mere 4K for optimal performance.

You might not like it, but that's the way it is.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

