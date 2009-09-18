Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbZIRSs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbZIRSs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbZIRSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:48:21 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:41587 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516AbZIRSsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:48:20 -0400
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Problems booting 2.6.31 on Fedora 8
Date: Fri, 18 Sep 2009 22:48:20 +0400
User-Agent: KMail/1.9.9
References: <4AB3C9A8.4060700@candelatech.com>
In-Reply-To: <4AB3C9A8.4060700@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909182248.21032@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm having troubles booting 2.6.31 on Fedora 8.  The same kernel
> boots fine on F11, but on F8, it cannot find the root logical volume.
>
> One thing I notice is that F11 uses root=/dev/mapper... and F8 uses
> root=/dev/VolGroup00/LogVol00 in grub.  It's not clear to me what
> the value of mapper should be...is there some way to figure this
> out from an older kernel (2.6.29) that boots fine?

I've recently faced a very similar problem, trying to boot some "modern" 
kernel on debian etch system.

It was solved by putting more recent lvm2 binary into initrd.

