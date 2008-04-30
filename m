Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbYD3WPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbYD3WPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYD3WPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:15:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:41163 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbYD3WPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Dif+k5C4CVHgMwRa6UO+Fat/tBbcdHNjy5qTo8sgKHToX3iZqergQqcoR+ekGgx4/otSwXGD3zv4ukZBfKEMB0D0K3S/j5DUmv/sy+gsnqJCW6G0RM1PjeGPOS8zlbU9jGjtPYad26Cisd7TFHlLl33nvycUbTK3uwm9PVFgXnY=
Message-ID: <4818EF7B.4040202@gmail.com>
Date: Thu, 01 May 2008 02:15:23 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove NexGen support (fwd)
References: <20080429081729.GA3921@ucw.cz> <20080430213457.GD18536@elf.ucw.cz>
In-Reply-To: <20080430213457.GD18536@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek пишет:
> Hi!
> 
>> It is claimed that NexGen CPUs were never shipped:
>>
>> http://lkml.org/lkml/2008/4/20/179
>>
>> Also, the kernel support for these chips has been broken for
>> a long time, the code intended to support NexGen thereby being
>> essentially dead.
> 
> Are you sure it never shipped? Wikipedia seems to suggest it did ship.
> 
> http://www.cpu-info.com/index2.php?mainid=Nx586&page=5
> 
> ...FPU for nexgen was never shipped, that implies that CPU did ship.

The main reason for removing the NexGen support was that the latter
had effectively been broken for G-d knows how many years. As a person
somehow involved into embedded development, I simply could not resist
to trim a few dozen bytes of dead binary code off vmlinux. Besides,
the change is trivially revertable (just checked that), and in case
that somebody owns a NexGen box and complains, that can be addressed
in a matter of minutes.

Dmitri

> 
> 								Pavel
> 

