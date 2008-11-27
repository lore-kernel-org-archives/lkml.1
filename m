Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYK0Nh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYK0Nh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYK0Nhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:37:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:60789 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYK0Nht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:37:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=C6lCpNYg3CVDyVBJLEIAV+FoPeFf3XIHHOCP72+1ACiBkcaK5vAY6bC0x3V991bmER
         z2gMgllP4KUMFcuoRoqXUAkfP9m8dkYVh5r6NWdq4XyLeFn2ybOi2zEAbGJeeqClr5Pi
         0gNmzg+D39/MT9Kbn99sV1otqMhLLR8iLDhhY=
Message-ID: <7c86c4470811270537y57577314we44d3d81b5f7d4a7@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:37:47 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Andi Kleen" <andi@firstfloor.org>, "David Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811271430470.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	 <20081127113115.GH6703@one.firstfloor.org>
	 <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
	 <20081127.034247.72331360.davem@davemloft.net>
	 <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain>
	 <20081127123811.GJ6703@one.firstfloor.org>
	 <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com>
	 <alpine.LFD.2.00.0811271430470.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 2:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 27 Nov 2008, stephane eranian wrote:
>> That's true for Intel.
>> On AMD64, I think you can get at most one sample out of a irq-off
>> region using IBS.
>
> Exactly the same amount which you get with the NMI/self_IPI out of an
> irq-off region.
>
Why would you get only one sample per irq-off region if you use NMI?
I would think you could get multiple, depending on your sampling period
and the size of the region.
