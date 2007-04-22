Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXDVMPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXDVMPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXDVMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:15:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:59165 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbXDVMPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G5rw0cAZEEg0SqhUYfdfcX/x1drF8bPanTo+Uud5AactoQfQ2SYxSyLmcEFWIT45EnukApz1QmNsI0PQgcA0CiNBiy8xRsC/vjyiJLmMswB1KQhbrYFKs0FK6xnr3OPsQpD8lyquxBqQXg8/YaJ0Tf3Wy3sMNF2A3u3/W9XHVq4=
Message-ID: <5a04609e0704220515h4049afas4dc98b90e66d1d16@mail.gmail.com>
Date: Sun, 22 Apr 2007 15:15:22 +0300
From: "Sergey Yanovich" <ynvich@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070422013411.45105.qmail@web36709.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4627D402.8020107@gmail.com>
	 <20070422013411.45105.qmail@web36709.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Finally, tifm_sd module needs to be manually inserted.
>
> By the way, the driver emits custom uevent when the new card is detected. I was going to look at
> this some day in the future, but if you want to mess a little with hotplug scripts the issue can
> be easily solved.

It would be nice if you to provide a sample script. Unfortunately,
hotplug scripts are distribution specific. And internal knowledge of
your modules is required to write one.

For a typical, non-linux-geek user there are just two states of the device -
available and not available. Ububtu is famous for its end-user support.
They ship your driver since linux-2.6.17. But they pack it in one module.
And that is _much_ easier, then a hotplug script.

And maybe, you would care to create a branch in you repository for
in-the-tree compiles.

> As I already said before, many of the complications exist because this is  an universal adapter,
> and memorystick support is quite near in the queue.

The scope of your project is exceptionally wide. You plan to develop a whole
new layer for memorystick as a part.

At the same time, the [tifm_sd] code is device specific, and [tifm_7xx1]
code is also device specific. And both modules depend on the same device
(of family of devices). That makes me think that a bus/controller/slot
construction is not going to make thing any easier, but adds complexity.

In case of MMC/SD all abstraction has already been separated by the mmc
layer, in case of MS it is up to you, how to implement.
