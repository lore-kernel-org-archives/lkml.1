Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYEPUSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYEPUSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYEPURt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:17:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:38497 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYEPURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xJ3wQOKsJEmndK2S0L5RVtkB/gt2BjkX1vCmvS0bXubbWWKb7BYyuPA7b4etAAt/CcVodLSfwni1JYoY3nNozDB8wcMbfRPjeX2GqGUUu7ZwXIyjosL8hTP7ibhbGdgghWxRAr2ZUCLYBv9i7qRPhi+wIusRLc2qN/exHqby5So=
Message-ID: <38b2ab8a0805161317i161e6b12w60ae21b4727de6ea@mail.gmail.com>
Date: Fri, 16 May 2008 22:17:46 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: How to avoid data copies in a driver ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080515135901.GX7577@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
	 <20080514200250.GB7579@csclub.uwaterloo.ca>
	 <38b2ab8a0805150044q3f336d64v20dd5ac78a2c1af2@mail.gmail.com>
	 <20080515135901.GX7577@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 3:59 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, May 15, 2008 at 09:44:37AM +0200, Francis Moreau wrote:
>> So I would need to map this pointer into the kernel space, then fill it, take
>> care of cache coherency, unmap the kernel pointer.
>>
>> Do you have any example of that in the kernel tree ?
>
> I was asking if that would work. Does the to_user and from_user work on
> a pointer from user space if that pointer points at a memory mapped
> file?

I would say yes but I'm not really confident.

-- 
Francis
