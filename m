Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZB1IMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZB1IMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZB1ILZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:11:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZB1ILY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:11:24 -0500
Message-ID: <49A8F0E5.10307@zytor.com>
Date: Sat, 28 Feb 2009 00:08:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: does boot loader check uncompressed kernel size?
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org>	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>	 <49A8EA1A.50802@kernel.org> <20090228074740.GA7581@localhost> <86802c440902272354s147aa88x2be99b48f2097b67@mail.gmail.com>
In-Reply-To: <86802c440902272354s147aa88x2be99b48f2097b67@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Feb 27, 2009 at 11:47 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> [Yinghai Lu - Fri, Feb 27, 2009 at 11:39:06PM -0800]
>> | wonder if boot loader check uncompress size aka vmlinux size in bzImage
>> | before it find one good position for bzImage...?
>> |
>> | YH
>> |
>>
>> At least for x86-64 in grub-1.96 I didn't find such a check.
>> Btw, but why should it care? Or you mean something else?
> 
> thinking about Jeremy's brk patches that may use ram after _end blindly...
> 

We already do that.  Jeremy's brk patches just formalizes it.

	-hpa

