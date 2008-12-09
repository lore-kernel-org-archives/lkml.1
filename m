Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbYLIL7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbYLIL7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYLIL7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:59:41 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:42839 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYLIL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cslyUrdRUTik+TmYnQRqIb6MbYRlzk4Voo+75Tv5FAL/O/YSZRu87vq+jIGLH3epPT
         HPBqr/9DsqdVe3rpAehQsbB5mrxorCDWM111J5zc3oOv1W/W+K7LYZdir/GIj6oDZeZb
         jM0XpYAbUwC0qh0TBfhTPcf6YdD8HJFwrSGiw=
Message-ID: <12bfabe40812090357s77a7fca8ya35747d9f5afd2d7@mail.gmail.com>
Date: Tue, 9 Dec 2008 12:57:12 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <871vwheg9o.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	 <493CF65B.30408@jp.fujitsu.com> <493D0D42.2090203@linux.intel.com>
	 <12bfabe40812082154y188e9167vd37589b758d9868d@mail.gmail.com>
	 <871vwheg9o.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 12:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
> "Giangiacomo Mariotti" <gg.mariotti@gmail.com> writes:
>
>> On Mon, Dec 8, 2008 at 1:04 PM, Andi Kleen <ak@linux.intel.com> wrote:
>>> Also it might be really some problem with this particular CPU.
>>>
>>> -Andi
>>>
>> It might be interesting to notice that booting a different distro and
>
> Does that different distro have machine checks enabled, was
> mcelog installed and did you wait 5 minutes for mcelog's cronjob to run?
>

That distro is SystemRescueCd v1.1.3(2.6.27.7) 64bit and yes it has MCE
enabled and it logged the usual single MCE after booting into it. From there
I mounted my debian 64 bit(2.6.27.8) partition, chrooted into it and kexeced
my 64bit 2.6.27.8(which, if booted directly from power up, gives the
usual single MCE after boot)
kernel and this time no MCE appeared. I still haven't rebooted and no
MCE appeared.

>> then doing a kexec from that into my 2.6.27.8 make the mce log
>> disappear.
>
> Yes of course if it comes out of BIOS POST then there won't be another
> one on kexec.
>
> -Andi
>
> --
> ak@linux.intel.com
>
