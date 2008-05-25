Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYEYEHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYEYEHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYEYEHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:07:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYEYEHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:07:00 -0400
Message-ID: <4838E5D4.4050708@zytor.com>
Date: Sat, 24 May 2008 21:06:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use structs instead of hardcoded offsets in x86 boot
 decompressor.
References: <1211579968-15227-1-git-send-email-krh@redhat.com>	<20080523210744.52fe7fde@bree.surriel.com>	<4837B2DD.908@zytor.com> <20080525000330.3eedd788@riellaptop.surriel.com>
In-Reply-To: <20080525000330.3eedd788@riellaptop.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Fri, 23 May 2008 23:17:01 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Uhm... except it doesn't live at address zero, at all.
>>
>> It's called "zeropage" because we used to recycle it into 
>> empty_zero_page, a long long time ago.
>>
>> The bootparms structure is pointed to by %esi being passed from the 
>> setup code to the decompressor to the kernel.
> 
> Then why does dereferencing the uninitialized
> pointer work, both in the code before and after
> the patch?
> 
> What am I misssing?

Heck if I know.  It definitely *shouldn't* work...

	-hpa
