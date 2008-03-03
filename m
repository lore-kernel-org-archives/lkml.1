Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYCCPuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYCCPuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYCCPuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:50:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:27986 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbYCCPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:50:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mkeK19zV6zdCCUX0r23DG4VsEzPUvSo4cdVX3Kap27Glfo1mXgTJeqob0bA22MF7xbmne2qtGL030ObKDUHbKoalUWU5JdJXnxpjgnBX//7tkAd99lOYNbowS0wdnvfBReKnKPEaINnAzoU2lHbBskhGYW+jcTfj/Pfv0uD5b6s=
Message-ID: <b6fcc0a0803030750t1430171dib6497c980deee265@mail.gmail.com>
Date: Mon, 3 Mar 2008 18:50:01 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Holger Kiehl" <Holger.Kiehl@dwd.de>
Subject: Re: sysfs: duplicate filename '74' can not be created
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803031444570.17218@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0803031444570.17218@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/08, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
> I get this approx. 4 hours after booting into 2.6.24.3 (2.6.23.16 worked
> fine). This system has 4 CPU's (single core) and 8GB ram. Here some more
> details:
>
>
> Mar 3 13:36:56 helena -- MARK --
> Mar 3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be
> created
> Mar 3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

> Mar 3 13:54:05 helena kernel: Code: 48 8b 04 c2 49 89 04 24 55 9d 31 c0
> c1 eb 0f 48 85 d2 0f 95
> Mar 3 13:54:05 helena kernel: RIP [<ffffffff80279170>]
> __kmalloc_track_caller+0x85/0xb9
> Mar 3 13:54:05 helena kernel: RSP <ffff8101dad09da8>
> Mar 3 13:54:05 helena kernel: ---[ end trace b8695bfb4832866d ]---

> Any idea what is causing this? Kernel 2.6.23.* seems to be fine.

Turn CONFIG_USER_SCHED off.

I'll look at why oops happened.
