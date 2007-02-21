Return-Path: <linux-kernel-owner+w=401wt.eu-S1423116AbXBUVBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423116AbXBUVBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423117AbXBUVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:01:43 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:55460 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423116AbXBUVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:01:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eFZ74L+wslDMJ6yZtLci6+B+sELiIKjfDuUF0O8EbHOP8p76eyoL428lw4oqTSgdPb2kznfKcvVqYWYvCzXhmOfQARKLHd35NdV6YeC2Gu+upUSAbxaLGjp+fiz24Yj0jjaLWZxG9fUMmThLsqnwfT84Lh4XGdSHpO4abCm1thQ=
Message-ID: <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
Date: Wed, 21 Feb 2007 22:01:40 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Vincent Legoll" <vincent.legoll@gmail.com>
Subject: Re: libsata doesn't like bus without master
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4727185d0702211247r796a2f4fte8b9511aa6864452@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4727185d0702211241v63549a77ye1023e9ff802c24a@mail.gmail.com>
	 <4727185d0702211247r796a2f4fte8b9511aa6864452@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Vincent Legoll <vincent.legoll@gmail.com> wrote:
> Argh I think I screwed the mail threading, I was refering to:
>
> http://ussg.iu.edu/hypermail/linux/kernel/0702.1/1060.html
>
> From: Patrick Ale
> Date: Sun Feb 11 2007 - 05:28:21 EST
>
> Sorry

Yea, I know.. I mail too much.. too much time at hands and all ;-)

But serious, The second "abnormal" error "ATA: abnormal status 0x8 on
port 0xF88597DF", I got feedback from, by Tejun. He confirmed that, as
I thought, this was a cosmectic error messages for "No devices found".

The first one got some debate as if it was legal to have a slave
without a master and all and the last thing I saw written on this
email that we (that is, the linux developers and the maintainers, I
dont code anything other than 'Hello world' and even that might
segfault) should support it and if we dont yet, fix it.


Question for you tho, since I have two laptops with the same chipset
and more ore less same configuration (Siemens LifeBook E series with
the same DVD writer and an HP laptop), do you use native SATA mode? or
Legacy/Compatible mode?

In the latter case it might explain why you see one master connected
to one bus and a slave to the other. If you use legacy SATA mode you
should just see drive 0 and drive 1.

At least, that's how it works here :)


Patrick
