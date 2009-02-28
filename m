Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZB1UnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZB1UnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZB1Umx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:42:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:18569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZB1Umx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dSP62xFvJkFPhUEvzL21mfrYpLKhFRJFyZ9hCNSmIepwBhiA+/ZhxSGVlR4MsiPmyQ
         PJnosZ3Go0+yEDLKtypg96PvnRhUW5aiz+clhVgV7GEsxhYahnfD0C5IZABFkS7UbIjC
         5Xg0jco8zTMzcdg3fMFYdI4iDKgcXSQLkAIrw=
MIME-Version: 1.0
In-Reply-To: <49A8F0E5.10307@zytor.com>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
	 <1235785882-17580-4-git-send-email-jeremy@goop.org>
	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>
	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>
	 <49A8EA1A.50802@kernel.org> <20090228074740.GA7581@localhost>
	 <86802c440902272354s147aa88x2be99b48f2097b67@mail.gmail.com>
	 <49A8F0E5.10307@zytor.com>
Date: Sat, 28 Feb 2009 12:42:50 -0800
X-Google-Sender-Auth: d2186ded3133df4f
Message-ID: <86802c440902281242h76bc601bu70c8b42444f58f72@mail.gmail.com>
Subject: Re: does boot loader check uncompressed kernel size?
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 12:08 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> On Fri, Feb 27, 2009 at 11:47 PM, Cyrill Gorcunov <gorcunov@gmail.com>
>> wrote:
>>>
>>> [Yinghai Lu - Fri, Feb 27, 2009 at 11:39:06PM -0800]
>>> | wonder if boot loader check uncompress size aka vmlinux size in bzImage
>>> | before it find one good position for bzImage...?
>>> |
>>> | YH
>>> |
>>>
>>> At least for x86-64 in grub-1.96 I didn't find such a check.
>>> Btw, but why should it care? Or you mean something else?
>>
>> thinking about Jeremy's brk patches that may use ram after _end blindly...
>>
>
> We already do that.  Jeremy's brk patches just formalizes it.
>

No, after we extend reserve_early from 64bit to 32bit, we don't use
RAM blindly in early stage.

YH
