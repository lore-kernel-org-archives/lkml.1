Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYAZTzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYAZTzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 14:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYAZTz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 14:55:29 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:12741 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYAZTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 14:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dluha0sareXvhq09K2vVLvv74c2/HgdgfQXRGZZPeIFheJhQKtT7VsKE2/30O7iv0ax9VNj/+cq3YCepZV0Ow5Yv60EHEORsF62IjUbR4GD31Bwxxi7uUtCgZh5PR7BRtvNTk0saonCR9TXWbXCi5Rz+71L70J7ri3Pip+gjwN0=
Message-ID: <8b67d60801261155m36e05f9dx359787b332cb814@mail.gmail.com>
Date: Sat, 26 Jan 2008 19:55:27 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
Subject: Re: kobject oops with maple bus
Cc: "Greg KH" <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1201377200.6672.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201377200.6672.10.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/2008, Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> Greg,
>
> Just updated my git to the latest sources and get these (seemingly non-fatal) oops with the Dreamcast maple bus. I'll investigate further, but they may mean something to out out of the box.
>
> Adrian
>
>
>
>
> dreamy:~# [    0.000000] Linux version 2.6.24-gf0ea9c3d-dirty (adrian@bossclass) (gcc version 3.4.6) #328 PREEMPT Sat Jan 26 19:45:30 GMT 2008
> [    0.000000] console [sercon0] enabled
> [    0.000000] Booting machvec: Sega Dreamcast
> [    0.000000] Node 0: start_pfn = 0xc000, low = 0xd000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   Normal      49152 ->    53248
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[1] active PFN ranges


Oh, and I've just noticed everythung appears to be timed to 0 too. Very odd.
