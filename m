Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458Ab0A1FhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab0A1FhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 00:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833Ab0A1FhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 00:37:21 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60542 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0A1FhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 00:37:21 -0500
MIME-Version: 1.0
In-Reply-To: <20100128042338.GA7004@kroah.com>
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org>
	 <1264602246-12880-4-git-send-email-ngupta@vflare.org>
	 <4B610BA6.2020009@vflare.org> <20100128042338.GA7004@kroah.com>
Date: Thu, 28 Jan 2010 11:07:20 +0530
Message-ID: <d760cf2d1001272137l3c4f7e48md37c3ea9ef509222@mail.gmail.com>
Subject: Re: [PATCH 3/3][resend] set block size to PAGE_SIZE and some cleanups
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 9:53 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Jan 28, 2010 at 09:29:34AM +0530, Nitin Gupta wrote:
>> [replace stat_*() with rzs_stat*()]
>> ---
>>
>> ramzswap block size needs to be set to PAGE_SIZE
>> to avoid receiving any unaligned block I/O (happens
>> during swapon time). These unaligned access produce
>> unncessary I/O errors, scaring users.
>>
>> Also included some minor cleanups.
>
> Such as?
>
> Could you break this into 2 patches, one the block size stuff, and the
> other the cleanups?  Remember, 1 patch does 1 thing.
>

I thought large number of patches is not desirable, so I merged lot
of stuff in one. I will resend 'v2' patches with proper breakup.

Thanks,
Nitin
