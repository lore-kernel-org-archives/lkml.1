Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbZG3OPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbZG3OPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZG3OPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:15:08 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:51258 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZG3OPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r7gDd34i9jw0g5anQOiwsww/Jk05lL0UGpPgfZiTrufAx8osoKzaC9+EvLnMqXso7g
         8bZHsxKMmm2IMSdb6nwW6DR1lQmDGNI78/whqn8oRRzZPtki2oSlOZm2vt8QGNq2m711
         tTj/JzxhmePV5i5cGab412BxglsOQJwm0cPBI=
MIME-Version: 1.0
In-Reply-To: <4A71A483.30507@linutronix.de>
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 
	<4A719A27.8050509@linutronix.de> <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com> 
	<4A71A483.30507@linutronix.de>
From: vimal singh <vimal.newwork@gmail.com>
Date: Thu, 30 Jul 2009 19:44:46 +0530
Message-ID: <ce9ab5790907300714u5c88f1cdk8c0387de5ba9f413@mail.gmail.com>
Subject: Re: [PATCH] [mtd] fixed faulty check
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stoyan Gaydarov <sgayda2@uiuc.edu>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, sr@denx.de, kay.sievers@vrfy.org,
       gregkh@suse.de, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 7:17 PM, Sebastian Andrzej
Siewior<bigeasy@linutronix.de> wrote:
> vimal singh wrote:
>>
>> What if you go to 'err_out' due to some other error?? Do not you need
>> to free 'info'?
>
> We have to and of_flash_remove() takes care of it.

that's correct...

>
> The initial patch would be shorter if
>  dev_set_drvdata(&dev->dev, info);
> would be moved prior the kzalloc()
>
> Sebastian
>



-- 
---
Regards,
\/ | |\/| /-\ |_

____      __o
------   -\<,
-----  ( )/ ( )
