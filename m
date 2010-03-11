Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab0CKWJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:09:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43878 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab0CKWJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:09:20 -0500
Message-ID: <4B996A05.1030907@zytor.com>
Date: Thu, 11 Mar 2010 14:09:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Daniel Taylor <Daniel.Taylor@wdc.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition
 for > 512B sector
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org><873a0h1p2c.fsf@devron.myhome.or.jp><876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com><87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com><87zl2j9muz.fsf@devron.myhome.or.jp><87wrxkw52s.fsf_-_@devron.myhome.or.jp><87sk88w4xk.fsf_-_@devron.myhome.or.jp><3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com> <873a07oyts.fsf@devron.myhome.or.jp> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com> <4B99677B.80001@zytor.com> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD91@wdscexbe01.sc.wdc.com>
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD91@wdscexbe01.sc.wdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 02:06 PM, Daniel Taylor wrote:
>
> BIOS failures prior to loading the kernel are not Linux'
> responsibility.  Confused BIOS will still fail, even if the
> patch is not implemented,  so how does that effect the
> acceptance of a patch that fixes post-boot behavior?
>

I didn't say it does.

>>
>> I would consider this a bugfix.  As such, it should be pushed outside
>> the merge window.
>>

Just in case I wasn't clear enough -- this patch is a bugfix and should 
be pushed upstream as long as it is technically ready.

	-hpa
