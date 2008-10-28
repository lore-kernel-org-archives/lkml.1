Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYJ1ODT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYJ1ODT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYJ1ODJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:03:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:16536 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYJ1ODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PUBHBog4HEnXiR8QB2Cjsawno1ICSPcHHwzfrslH81O1tHMEO4viwUsDh/25kteSHl
         g+i+socOTjcSDWl4NXoziKs/SomkMHAqK4VBB9Z1ZvWVQo3bNr7hAe0fDDN8YAWm+yuA
         cdBQfNsskZCnqSagJdt11q5EVsYwIMZnTnYco=
Message-ID: <40a4ed590810280703q665ed37du3f8c25df0855dc5d@mail.gmail.com>
Date: Tue, 28 Oct 2008 15:03:03 +0100
From: "Zeno Davatz" <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
In-Reply-To: <20081028135730.GM22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40a4ed590810280648u2fc01a6dybfe3d5f49aa29f94@mail.gmail.com>
	 <20081028135730.GM22217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That Pull is from right after Linus released 2.6.28-rc2. I always pull
after Linus releases an rc and notifys everyone through the list.

I will pull again right now and try again.

Best
Zeno

On Tue, Oct 28, 2008 at 2:57 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Oct 28 2008, Zeno Davatz wrote:
>> Dear List
>>
>> After my latest git pull from
>>
>> url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>
>> I done
>>
>> make silentoldconfig
>> make modules_install
>>
>> copied the bzImage to /boot and ran lilo.
>>
>> When I want to boot into 2.6.28-rc2 I get:
>>
>> [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
>>
>> Also see my screenshot:
>>
>> http://farm4.static.flickr.com/3213/2980651545_de81680bf9_o.jpg
>
> How recent is that pull? This looks like something fixed in-between -rc1
> and -rc2. So I'd double check that you are after or on -rc2 and that you
> are booting the right kernel.
>
> --
> Jens Axboe
>
>
