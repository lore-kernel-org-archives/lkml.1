Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbZFORsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbZFORsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbZFORs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:48:27 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65196 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbZFORsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Eyx08B4YCQKR5PFYOdsnVhW4Q2yHSGYIcV8S5ip+bLQyAwfq7IP4UpQZoPpV/Db6db
         sQ1KgNPbv3cGXvp4gvHCx/Q1Xf39E9kK3LaRUsY44IO/R5RgNuO2dn3yee/bgZAIWM/5
         wHtvSng0JaN9vDennjkTRuQ72B2oKCCZCyG80=
Message-ID: <4A36887C.1050906@gmail.com>
Date: Mon, 15 Jun 2009 19:44:28 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <4A3681C2.5010508@am.sony.com>
In-Reply-To: <4A3681C2.5010508@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Marco wrote:
>> This is a second attempt at mainlining Pramfs. The first attempt was
>> back in early 2004 by MontaVista. Since then the kernel code has almost
>> been completely rewritten. So my first item on the list was porting the
>> code on a recent kernel version. After that I added the XIP support.
> 
> It's very nice to see this technology revived.
> 
> Is the information at:
> http://pramfs.sourceforge.net/
> and
> http://pramfs.sourceforge.net/pramfs-spec.html
> still valid - particularly the latter?

Yep. at 99%. I've done some modifications due to the porting and there
will be some ones due to this review. I tried to talk with Steve
Longerbeam to update the site but without success. I'd like to update it.

> 
> It would be very nice to see this get mainlined.  I believe that
> one of the main uses for this is to store crash information
> over a reboot so the next kernel (not in crashing state) can have
> a better chance of dealing with it.  As such, I think
> it's important to keep the code paths for Pramfs short, synchronous,
> and unentangled with other kernel systems (block IO, page cache, etc.).
> 

Yes, I quite agree. I think that this kind of feature would be very
useful especially for the embedded world.

Marco
