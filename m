Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527Ab0ALGsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0ALGsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087Ab0ALGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:48:16 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39655 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0ALGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:48:15 -0500
MIME-Version: 1.0
In-Reply-To: <1263275308.23507.18.camel@barrios-desktop>
References: <1263271018.23507.8.camel@barrios-desktop>
	 <d760cf2d1001112130p8489b93uccd6a4650ff4a4a8@mail.gmail.com>
	 <1263275308.23507.18.camel@barrios-desktop>
Date: Tue, 12 Jan 2010 12:18:14 +0530
Message-ID: <d760cf2d1001112248r7a41d5c8n7fe7e2611cd14e87@mail.gmail.com>
Subject: Re: [PATCH] Fix reset of ramzswap
From: Nitin Gupta <ngupta@vflare.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:18 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Tue, 2010-01-12 at 11:00 +0530, Nitin Gupta wrote:
>> On Tue, Jan 12, 2010 at 10:06 AM, minchan.kim <minchan.kim@gmail.com> wrote:

>>
>> Are you sure you checked this patch?
>
>> This check makes sure that you cannot reset an active swap device.
>> When device in swapoff'ed the ioctl works as expected.
>>
> It seems my test was wrong.
> Maybe my test case don't swapoff swap device.
> Sorry. Ignore this patch, pz.
> Thanks for the reivew, Nitin.
>
> I have one more patch. But I don't want to conflict your pending
> patches. If it is right, pz, merge this patch with your pending series.
>

I will merge your patches with my pending series and add appropriate
signed-off-by lines.


> >From bf810ec09761b0f37eca7ba22d72fb2b1f2cba50 Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan.kim@gmail.com>
> Date: Tue, 12 Jan 2010 14:46:46 +0900
> Subject: [PATCH] Remove unnecessary check of ramzswap_write
>
> Nitin already implement swap slot free callback.
> So, we don't need this test any more.
>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>


Great catch! thanks.

I think, we should avoid adding linux-mm to CC list (unless its about
xvmalloc allocator).
LKML alone should be sufficient.

Thanks,
Nitin
