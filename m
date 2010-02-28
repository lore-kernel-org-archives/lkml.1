Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968731Ab0B1PgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 10:36:18 -0500
Received: from mail.tmr.com ([64.65.253.246]:51689 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968708Ab0B1PgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 10:36:17 -0500
Message-ID: <4B8A8D68.1020809@tmr.com>
Date: Sun, 28 Feb 2010 10:36:08 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s limitation/bug?
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan>  <20100228080100.092c24c2@notabene.brown>  <alpine.DEB.2.00.1002271624480.12663@p34.internal.lan>  <4B89B44A.70005@tmr.com>  <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan> <170fa0d21002280633x2ea6a281tf53996834c46d831@mail.gmail.com> <alpine.DEB.2.00.1002281000120.22822@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1002281000120.22822@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>
>
> On Sun, 28 Feb 2010, Mike Snitzer wrote:
>
>> On Sun, Feb 28, 2010 at 4:45 AM, Justin Piszcz 
>> <jpiszcz@lucidpixels.com> wrote:
>
> [ .. ]
>
>>
>> How did you format the ext3 and ext4 filesystems?
>>
>> Did you use mkfs.ext[34] -E stride and stripe-width accordingly?
>> AFAIK even older versions of mkfs.xfs will probe for this info but
>> older mkfs.ext[34] won't (though new versions of mkfs.ext[34] will,
>> using the Linux "topology" info).
>
> Yes and it did not make any difference:
> http://lkml.org/lkml/2010/2/27/77
>
> Incase anyone else wants to try too, you can calculate by hand, or if you
> are in a hurry, I found this useful:
> http://busybox.net/~aldot/mkfs_stride.html
>
> I believe there is something fundamentally wrong with ext4 when 
> performing large sequential I/O when writing, esp. after Ted's comments.
>
> Justin.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
I'm going to have to do some testing now, I just tested ext4 against the 
raw speed of the device (single device test) and they were quite close 
to identical. I'm going to order one more drive to bring my test setup 
up to five devices, and do some testing on how it behaves.

More later.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

