Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbYERVAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbYERVAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYERVAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:00:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:24448 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYERVAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WJR27uSeLhf5amf4hlXEngLQYJlwNs9DZA6IIwWbZ0zyKCUS4ysZew0lN38A5v6xQKHOVJiXR45JEOf8FDtU/GfSzOkC0YPTIprtM4Rb5yvzi/CAjCvM2CNl0UIYocJsTnQ0HaSBqbjvG8MUPD1NH1vZP/q0n+3e2p6buPsyjlc=
Message-ID: <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
Date: Sun, 18 May 2008 14:00:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080518164127.2236d82a@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518014111.4f32298b@googlemail.com>
	 <86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
	 <20080518164127.2236d82a@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 8:41 AM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> On Sat, 17 May 2008 20:55:20 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> On Sat, May 17, 2008 at 5:41 PM, Ciaran McCreesh
>> <ciaran.mccreesh@googlemail.com> wrote:
>> > The commit 3def3d6ddf43dbe20c00c3cbc38dfacc8586998f (x86:
>> > insert_resorce for lapic addr after e820_reserve_resources) causes
>> > my x86_64 box to to lock up early on in the boot process. Reverting
>> > only this commit with current git head gives a successful boot.
>>
>> can you try to boot with apic=verbose? please don't revert that
>> patch...
>>
>> wonder if init_apic_mapping need some delay with that strange chipset.
>
> I don't see any additional information with apic=verbose with the
> broken kernel (although I only have a screen's worth of text that I can
> see -- the kernel doesn't get far enough to let me grab it). I've
> attached dmesg from a working kernel with apic=verbose in case that
> helps.

or try to boot with initcall_debug to see where did it hang.

YH
