Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZGOVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZGOVlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZGOVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:41:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59999 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZGOVlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:41:15 -0400
Date: Wed, 15 Jul 2009 17:40:52 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: regression post 2.6.30: device mapper fails on some logical
	volumes
Message-ID: <20090715214051.GB6399@redhat.com>
References: <200907151852.15121.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907151852.15121.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15 2009 at 12:52pm -0400,
Christian Bornträger <borntraeger@de.ibm.com> wrote:

> Hello Mike,
> 
> your patch
> commit 754c5fc7ebb417b23601a6222a6005cc2e7f2913
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Mon Jun 22 10:12:34 2009 +0100
> 
>     dm: calculate queue limits during resume not load
> 
> causes some problems during startup (/sbin/lvm vgchange -a y) on my s390 system.
> The logical volumes space-home and space-test dont come up (device-mapper: 
> resume ioctl faile: Invalid argument) and dmesg has:
> 
> [    4.450974] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-
> devel@redhat.com                                                                           
> [    4.567024] device-mapper: table: 253:0: target device dasdf1 is misaligned
...
> [    6.048168] device-mapper: table: 253:59: target device dasde1 is misaligned

Christian,

Which kernel are you using?  I believe these warnings have been fixed
with this commit (which should be part of 2.6.31-rc2):
ea9df47cc92573b159ef3b4fda516c32cba9c4fd

Mike

