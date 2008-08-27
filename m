Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYH0O52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYH0O52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYH0O5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:57:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51017 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYH0O5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:57:18 -0400
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'Bruce Leonard'" <brucle@earthlink.net>, Bruce_Leonard@selinc.com,
       linux-kernel@vger.kernel.org, Tim Anderson <tanderson@mvista.com>,
       linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080827143416.GA1371@logfs.org>
References: <1219817017.18027.149.camel@sauron>
	 <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
	 <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk>
	 <1219827692.7107.170.camel@pmac.infradead.org>
	 <20080827143416.GA1371@logfs.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 27 Aug 2008 17:47:43 +0300
Message-Id: <1219848463.18027.166.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Aug 2008 14:50:52.0487 (UTC) FILETIME=[4D5B3D70:01C90854]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 16:34 +0200, Jörn Engel wrote:
> They certainly can, but should they?  There may be some reason to prefer
> sysfs that should be self-evident - except that I'm a bit thick and seem
> to need it spelled out.  Or maybe I've just become disillusioned with
> the practice of replacing crappy interfaces (ioctl here) with other
> crappy interfaces (sysfs here) and having to support both for all
> eternity.  sysctl, ioctl, proc, sysfs, debugfs, netlink, ... -
> individually they all suck in their own peculiar way.  But together they
> create a mess I no longer dare to name.

The plus of sysfs I see is that I can add more files to expose more
information in sysfs, while I can not change MEMGETINFO ioctl. E.g., I
need to expose sub-page size to user-space, and I cannot do this with
MEMGETINFO.

> So what was the reason again why mtd needs two userspace interfaces
> instead of just one?

I would like to make udev creating MTD devices, instead of creating them
by hands. Adding MTD to LDM would anyway introduce corresponding sysfs
files, right? This means we would have one more interface anyway.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

