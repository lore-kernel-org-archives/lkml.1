Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbYCFPS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbYCFPS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759107AbYCFPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:18:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbYCFPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:18:16 -0500
Message-ID: <47D00B16.6040004@zytor.com>
Date: Thu, 06 Mar 2008 07:17:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu>
In-Reply-To: <20080306102712.GE13391@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Pawel Plociennik wrote:
>>> Hi Andrew and other *real* hackers,
>>>
>>> I have sent a *last* version of a patch which it has added a new kernel parameter chroot=
>>> It were discusioned a *long time* on a lkml so I hope that it will has been applied.
>> It has been discussed and *rejected* a large number of times.
>>
>> This is completely useless bloat.
> 
> why is it useless? Would it be more acceptable were it made dependent on 
> a .config option?
> 

It's useless because it's exactly and trivially replaceable with:

	init=/path/to/any/sbin/chroot /newroot /sbin/init

The last thing we want is to pile more stuff into the in-kernel 
initialization code, and no, making it a config option makes it even worse.

	-hpa
