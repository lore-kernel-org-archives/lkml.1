Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYITIdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYITIdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYITIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:33:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:23530 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYITIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:33:41 -0400
Message-ID: <f488382f0809200133q6257219and62a6d1572312c71@mail.gmail.com>
Date: Sat, 20 Sep 2008 01:33:40 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: mcount_addr defined but not used
Cc: akpm@linux-foundation.org, mingo@elte.hu,
       "Steven Noonan" <steven@uplinklabs.net>
In-Reply-To: <f488382f0809200131p4d29839cge11ad4a7b543d8b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080920061659.GF25713@elte.hu>
	 <1221897638-16272-1-git-send-email-steven@uplinklabs.net>
	 <f488382f0809200131p4d29839cge11ad4a7b543d8b5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 1:31 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Sat, Sep 20, 2008 at 1:00 AM, Steven Noonan <steven@uplinklabs.net> wrote:
>>
>>  /*
>> - * Since MCOUNT_ADDR may point to mcount itself, we do not want
>> - * to get it confused by reading a reference in the code as we
>> - * are parsing on objcopy output of text. Use a variable for
>> - * it instead.
>> - */
>> -static unsigned long mcount_addr = MCOUNT_ADDR;
>> -
>> -/*
>
> This line looks like a typo. I think I screwed up a comment block
> there. I'll re-submit a patch in a moment.
>
Nevermind, I read it wrong. diff is messing with my head.
