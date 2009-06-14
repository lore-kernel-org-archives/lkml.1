Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZFNHVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZFNHVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZFNHUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:20:06 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47489 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZFNHUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hwN9Q1B6AyVGZFTOYyAM7gDqpvRxuDBAXjJMV7fFxH0pccPZM0MS3/1RS3GPXY2r74
         ourIGpUPvGdDXNHb1tXrgzTHGIjIsM/T7YLL1o6dtq197/wZRvFkcoljGQckHec4Ajr/
         93vatYUHhpmt7TDZGUrZtPAFEtXy/4qyeWWcw=
Message-ID: <4A34A3B8.2050502@gmail.com>
Date: Sun, 14 Jun 2009 09:16:08 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 08/14] Pramfs: Makefile and Kconfig
References: <4A33A802.8040507@gmail.com> <1244901732.5982.221.camel@desktop>
In-Reply-To: <1244901732.5982.221.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Sat, 2009-06-13 at 15:22 +0200, Marco wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Makefile and Kconfig.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>>
> 
> You should move this patch to 11 of 14, as I think that is the point
> when the filesystem can actually be enabled and function. If this series
> is only applied up to this patch you can get build failures if you
> enabled PRAMFS, XIP, or any of the other features. Also breaking out the
> individual features menuconfig options like XIP, and write protect, etc,
> into their respective patches would be nice.
> 
> Daniel
> 
> 

Ok Daniel thanks for your comments. Actually I split the patches by
functionality because I think that for this series it's a little bit
complicated to follow a sequence so as not to have building failure but
I can try. I think the only part I can split is the XIP. I think there
will be a lot of comments so I'll wait for other comments before to
re-submit other patches.

Marco

