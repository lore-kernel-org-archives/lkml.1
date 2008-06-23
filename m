Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYFWXlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYFWXlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYFWXk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:40:59 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:21685 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbYFWXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Vcq/rhvAYccebZ7juemubUPvFQpKCT3S3flmB5I7CuImJ2MKrjPlFfACXYLfVnRpS0
         8ikB9UASeG23+Y4UDQgYlKiJ/blhRaEkJmlpwIKKzLzyBPK7b634n7h/DHw4BNTeq1yQ
         mntVHC4M/oiLypcxdyKzj/zwU0hUfB143l+4Q=
Message-ID: <9929d2390806231640l7fc89221j6ff879d1e5005771@mail.gmail.com>
Date: Mon, 23 Jun 2008 16:40:56 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Taku Izumi" <izumi.taku@jp.fujitsu.com>
Subject: Re: [PATCH 0/3] e1000,e1000e,igb: make ioport free for adapters that need NO ioport resources
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       "Tomohiro Kusumi" <kusumi.tomohiro@jp.fujitsu.com>
In-Reply-To: <485F5EA5.9050503@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485B1B8E.1060108@jp.fujitsu.com> <485D4630.1090007@intel.com>
	 <485F5EA5.9050503@jp.fujitsu.com>
X-Google-Sender-Auth: 42ca3eb60dd59928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 1:28 AM, Taku Izumi <izumi.taku@jp.fujitsu.com> wrote:
> Dear Auke
>
>>> * [PATCH 1/3] e1000: make ioport free
>>> * [PATCH 2/3] e1000e: make ioport free
>>> * [PATCH 3/3] igb: make ioport free
>>
>> I think patch 2 and 3 are way too large since igb and e1000e can be
>> totally ioport
>> free at all times. There is no need to keep compatibility code for ioport
>> in those
>> drivers as it's unlikely that this will ever be needed.
>
> I left an old implementation in case adapters that need ioport resources
> appear,
> but it's true that these codes are a little redundant for igb and e1000e
> drivers.
>
>> So, perhaps you can remove the ioport code from those 2 drivers
>> (e1000e/igb)
>> completely and resubmit to Jeff Kirsher?
>
>  OK, I'll send them later.
>

The updated patchset looks fine.  ACK.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

-- 
Cheers,
Jeff
