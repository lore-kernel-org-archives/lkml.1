Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbYEPSfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbYEPSfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYEPSff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:35:35 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:4432 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYEPSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eKgwXR+ZAWiPitXjwTe13ehc19VTdjf1J2lm8CxwE8r9T7Lfkb22S9LizuQwTJTnvCJ/AtwjCDS11oy46/fN6dBotniCzQ0ocNwrZIhtH+5Le+agJJpCxWOQjMA2cx1I74WowvRy6WG92F+uvsP8t2AgcQY2rmHVlo1s3Nme8zQ=
Message-ID: <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com>
Date: Fri, 16 May 2008 20:35:32 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "David Greaves" <david@dgreaves.com>
Subject: Re: Regression- XFS won't mount on partitioned md array
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, "David Chinner" <dgc@sgi.com>,
       LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <482DCCCD.8020503@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482DC043.5000307@dgreaves.com>
	 <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
	 <482DCCCD.8020503@dgreaves.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this[1] patch fixed?

this patch is for 2.6.25.5 kernel

1: http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.25/block-do_mounts-accept-root-non-existant-partition.patch;h=097cda9928b434994dbb157065b2ca38e7cec3a1;hb=8cc4c3b370d59deb16c2e92165a466c82e914020

On 5/16/08, David Greaves <david@dgreaves.com> wrote:
>> Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use
>> mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7
>> does it work again?
> Yes, no probs.
>
> It came in prior to 2.6.25-rc1
> The machine has a root xfs filesystem with an internal log on a sata disk
> and a
> data filesystem on a partitioned array with an external log (also on the
> partitioned array).
> Only the partitioned array/external-log filesystem is affected.
>
> David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
