Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbZJQPUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbZJQPUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZJQPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:20:07 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59224 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZJQPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=RzeExyRVGf9PyHcmZ3BOT0x4rqaKAAfXDAyZoBEddROf1jXw+K3g2S0DgBtOakTVA/
         STR3zKxe+lQZXnWO9Wk4hnCGPy/z7yS3skOT6AkurmD2WtpTtL4CDyBTGB5fz0QEOGJ5
         u78gf8W2bfqrgfathzc/uU0C7k8huSty+7nro=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Sat, 17 Oct 2009 17:19:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: Ivo van Doorn <ivdoorn@gmail.com>, John Linville <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, users@host1.serialmonkey.com,
       Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910171654.03344.bzolnier@gmail.com> <1255792104.3434.2.camel@johannes.local>
In-Reply-To: <1255792104.3434.2.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <200910171719.24093.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 October 2009 17:08:24 Johannes Berg wrote:
> On Sat, 2009-10-17 at 16:54 +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> > I also used the opportunity to take a closer look at this driver and
> > it seems that it needlessly adds around 2 KLOC to kernel by duplicating
> > the common content of rt2800usb.h to rt2800pci.h instead of moving it
> > to the shared header (like it is done in the staging crap drivers):
> 
> Tell me you're kidding -- comparing 2k duplicated LOC with a driver that
> ships its own wifi stack?

Why would I be?

1) The patch is submitted to kernel _proper_ not kernel staging so I see
no excuse for duplicating 2-4 KLOC and it should be fixed.

2) The fact that the some staging driver consists in 90% of crap doesn't
mean that it doesn't have some good design ideas..  (i.e. abstracting chipset
registers access in a discussed case)
