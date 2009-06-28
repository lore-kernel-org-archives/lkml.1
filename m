Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZF1V6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZF1V6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZF1V57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:57:59 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57942 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZF1V57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:57:59 -0400
Date: Sun, 28 Jun 2009 22:57:54 +0100
From: Jamie Lokier <jamie@shareable.org>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090628215754.GA29896@shareable.org>
References: <19013.8005.541836.436991@samba.org> <alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr> <19014.56477.311713.975403@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19014.56477.311713.975403@samba.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org wrote:
> Hi Jan,
> 
>  > Can't we make this a runtime option?
> 
> John may be able to give you a more detailed answer, but the short
> answer is that it is much safer legally to not have the code in the
> binary kernel image at all.

Understood.

For those of us who don't want to omit the code, because we like
compatibility and we're not in affected countries, or for research, it
would be useful to have it as a mount option.

So there should be these compile-time options:

    1. CONFIG_VFAT_FS_DUALNAMES disabled:  Don't create shortnames.

    2. CONFIG_VFAT_FS_DUALNAMES enabled: Create shortnames, unless
       mount option "dualnames=no" is given, in which case that mount
       behaves as if CONFIG_VFAT_FS_DUALNAMES is disabled.

-- Jamie
