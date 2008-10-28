Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYJ1OT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYJ1OT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYJ1OTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:19:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYJ1OTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DdyFuMkhw0UYKFr2HoriTxQoo9lWHa5g3WQri8TwIP1EK/gCPm4nXx3u82jbwsZomj
         Wcyf1zHlZ6TYMFCEBxLwfag+XgY+ZIiqrBP+BEVQBiepObwY/A27m7gNNcG5/quqq88N
         IAH4XPBYtPNnPkN2QMpC53Sq5zgwls+X28x6U=
Message-ID: <40a4ed590810280719u718c01e4j73d14d958ccf55c1@mail.gmail.com>
Date: Tue, 28 Oct 2008 15:19:12 +0100
From: "Zeno Davatz" <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
In-Reply-To: <20081028140449.GN22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40a4ed590810280648u2fc01a6dybfe3d5f49aa29f94@mail.gmail.com>
	 <20081028135730.GM22217@kernel.dk>
	 <40a4ed590810280703q665ed37du3f8c25df0855dc5d@mail.gmail.com>
	 <20081028140449.GN22217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 3:04 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> (don't top post)
>
>> On Tue, Oct 28, 2008 at 2:57 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Tue, Oct 28 2008, Zeno Davatz wrote:
>> >> Dear List
>> >>
>> >> After my latest git pull from
>> >>
>> >> url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>> >>
>> >> I done
>> >>
>> >> make silentoldconfig
>> >> make modules_install
>> >>
>> >> copied the bzImage to /boot and ran lilo.
>> >>
>> >> When I want to boot into 2.6.28-rc2 I get:
>> >>
>> >> [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
>> >>
>> >> Also see my screenshot:
>> >>
>> >> http://farm4.static.flickr.com/3213/2980651545_de81680bf9_o.jpg
>> >
>> > How recent is that pull? This looks like something fixed in-between -rc1
>> > and -rc2. So I'd double check that you are after or on -rc2 and that you
>> > are booting the right kernel.
>>
>> That Pull is from right after Linus released 2.6.28-rc2. I always pull
>> after Linus releases an rc and notifys everyone through the list.
>>
>> I will pull again right now and try again.
>
> Please do, and if it still breaks then use netconsole or a serial
> console to capture all boot messages!

Ok, this worked, thanks! I am now on 2.6.28-rc2-00095-g49fdf67.

The only thing remaining is that my time is now

04:17

instead of

16:17

Any hints on that?

Best
Zeno
