Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZGOWIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZGOWIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZGOWIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbZGOWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:08:18 -0400
Date: Wed, 15 Jul 2009 15:08:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mike.miller@hp.com, jens.axboe@oracle.com
Subject: Re: [PATCH 0/3] cciss rmmod/scan-thread fixes
Message-Id: <20090715150809.8fd350b9.akpm@linux-foundation.org>
In-Reply-To: <20090714220239.22282.44414.stgit@bob.kio>
References: <20090714220239.22282.44414.stgit@bob.kio>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 16:02:40 -0600
Andrew Patterson <andrew.patterson@hp.com> wrote:

> The following series fixes several problems causing hangs while
> rmmoding the cciss driver. In the process of fixing these hangs, I
> also reworked the the logical drive scanning kernel thread to use one
> thread per driver rather than one thread per controller. I also added
> a sysfs attribute to kick off a controller scan.
> 
>  .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
>  drivers/block/cciss.c                              |  198 ++++++++++++++++++--
>  drivers/block/cciss.h                              |    7 +
>  3 files changed, 188 insertions(+), 24 deletions(-)
> 
> Andrew Patterson (3):
>       cciss: remove logical drive sysfs entries during driver cleanup.
>       cciss: use only one scan thread
>       cciss: kick off logical drive topology rescan through sysfs
> 

So I assume that these are intended to fix the problem which
cciss-fix-the-termination-of-the-scanning-thread.patch didn't fix?

Once we get this all sorted out, which kernel version(s) are we
targetting and why?

Thanks.

