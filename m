Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYLANvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYLANvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYLANvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:51:44 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:57990 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYLANvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZHZRmHXC17zVzr6b1YgQeQblxLa7kxXIZLP+5iFOVzFHZ2UIAb3SW7NiRt2cdu6AZi
         6ge4VcqP4X3f6KiTbpSjprmrT5jH8VI9bd2XN+hOoO4QomIDxJ9UBo249rpvbv7B7ewU
         QKIL5ofXzWaAt8B0njhSmj795jUXUvsRGCzjM=
Message-ID: <a6b9f31a0812010551h28c0841fxa2a26af4645df64@mail.gmail.com>
Date: Mon, 1 Dec 2008 22:51:42 +0900
From: "Hitoshi Mitake" <h.mitake@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Doug Thompson" <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20081130161504.GA25627@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129164736.0b5a71db.h.mitake@gmail.com>
	 <20081129192610.716a2d57.h.mitake@gmail.com>
	 <20081129105229.GA9643@uranus.ravnborg.org>
	 <20081129222449.e341f028.h.mitake@gmail.com>
	 <20081129180144.GA15533@uranus.ravnborg.org>
	 <20081130171604.dc3c8715.h.mitake@gmail.com>
	 <20081130083700.GA31644@elte.hu> <20081130092407.GA10802@elte.hu>
	 <20081201002056.d9f9204c.h.mitake@gmail.com>
	 <20081130161504.GA25627@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 01:15, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Hitoshi Mitake <h.mitake@gmail.com> wrote:
>
>> On Sun, 30 Nov 2008 10:24:07 +0100
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>> >
>> > the 32-bit build broke promptly - readq/writeq is a family of APIs that
>> > has to be either fully provided or not provided at all. The fix is below.
>>
>> Thanks for your fix and adding!
>> When will this patch be added to mainline?
>> I want to rewrite x38_edac.c to adapt new APIs.
>
> v2.6.29 at the earliest - if there are no regressions. A number of
> drivers use these APIs and usage is a bit messy - so bugs could be
> triggered, etc.
>
Thanks. What is URL of your repository?
I want to look your tree and test it.
