Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZF1WF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZF1WF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZF1WFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:05:19 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48186 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZF1WFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:05:19 -0400
Date: Sun, 28 Jun 2009 23:05:18 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: tridge@samba.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090628220518.GB29896@shareable.org>
References: <19013.8005.541836.436991@samba.org> <alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr> <19014.56477.311713.975403@samba.org> <20090628215754.GA29896@shareable.org> <alpine.LSU.2.00.0906290000360.9212@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0906290000360.9212@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> On Sunday 2009-06-28 23:57, Jamie Lokier wrote:
> >For those of us who don't want to omit the code, because we like
> >compatibility and we're not in affected countries, or for research, it
> >would be useful to have it as a mount option.
> >
> >So there should be these compile-time options:
> >    2. CONFIG_VFAT_FS_DUALNAMES enabled: Create shortnames, unless
> >       mount option "dualnames=no" is given, in which case that mount
> >       behaves as if CONFIG_VFAT_FS_DUALNAMES is disabled.
> 
> If you are not in an affected country, why would you even want
> to disable dualnames? [ on a per-mount basis...]

   1. To test it's behaviour, without changing the whole running system.

   2. To produce disk images which are the same as would be produced
      in an affected country, or would be produced by a Linux distro
      adopting the behaviour.

-- Jamie

