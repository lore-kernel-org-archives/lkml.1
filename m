Return-Path: <linux-kernel-owner+w=401wt.eu-S1764012AbYBZRyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764012AbYBZRyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762358AbYBZRyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:54:23 -0500
Received: from ns1.q-leap.de ([153.94.51.193]:54285 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761878AbYBZRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:54:22 -0500
From: Bernd Schubert <bs@q-leap.de>
To: Andre Noll <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Tue, 26 Feb 2008 18:54:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>,
       Johannes =?iso-8859-15?q?W=F6rner?= 
	<johannes.woerner@tuebingen.mpg.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20080226174314.GA30767@skl-net.de>
In-Reply-To: <20080226174314.GA30767@skl-net.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261854.19980.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andre,

On Tuesday 26 February 2008 18:43:14 Andre Noll wrote:
> Hi
>
> we are experiencing massive performance problems with two of our
> Linux servers that contain 3ware controllers on a Tyan mainboard and
> a couple of 1T disks.
>
> During the daily cron job that uses rsync to sync a 500G file system
> from another machine to the raid on the 3ware controller the load
> jumps up, and the machine becomes sluggish as hell. For example, an
> ssh login to that machine takes minutes to complete and ldap becomes
> unreliable while the rsync job is running. Even Nagios complains
> about the machine being down while rsync is running.

do you have the write-back cache of the controller enabled for your disks? 
When you disable this cache, the controller will also disable the disks, 
cause a write-performance between 3 to 8MB/s per disks.

Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
