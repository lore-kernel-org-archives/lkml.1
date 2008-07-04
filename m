Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYGDMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYGDMWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYGDMWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:22:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55446 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYGDMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:22:06 -0400
Message-ID: <486E15E8.5040303@firstfloor.org>
Date: Fri, 04 Jul 2008 14:22:00 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: next-0704: sparc64: build failure at arch/sparc64/kernel/sysfs.c
References: <a4423d670807040520v7604782crd209d64aad9343ff@mail.gmail.com>
In-Reply-To: <a4423d670807040520v7604782crd209d64aad9343ff@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> Hi
> 
> cc1: warnings being treated as errors
> arch/sparc64/kernel/sysfs.c:160: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:160: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:205: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:206: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:207: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:208: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:209: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:210: error: initialization from
> incompatible pointer type
> arch/sparc64/kernel/sysfs.c:211: error: initialization from
> incompatible pointer type
> 
> I think it is connected to

Thanks. Looks good. sparc64 was one of the architectures i wasn't able
to compile test. Greg, can you just fold the patch in please?

-Andi


