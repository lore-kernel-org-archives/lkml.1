Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbZGPFgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbZGPFgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbZGPFgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:36:14 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:58262 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbZGPFgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:36:14 -0400
From: Christian =?iso-8859-1?q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Organization: IBM
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: regression post 2.6.30: device mapper fails on some logical volumes
Date: Thu, 16 Jul 2009 07:36:04 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-release; KDE/4.2.4; i686; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200907151852.15121.borntraeger@de.ibm.com> <20090715214051.GB6399@redhat.com>
In-Reply-To: <20090715214051.GB6399@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907160736.09885.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 15 Juli 2009 23:40:52 schrieb Mike Snitzer:

>
> > [    6.048168] device-mapper: table: 253:59: target device dasde1 is
> > misaligned
>
> Christian,
>
> Which kernel are you using?  I believe these warnings have been fixed
> with this commit (which should be part of 2.6.31-rc2):
> ea9df47cc92573b159ef3b4fda516c32cba9c4fd
>
> Mike

Mike,

I see the problem with 2.6.31-rc3. Given the content of patch ea9df4...it might 
be of interest that my dasd devices have a hard sector size of 4k:

$ sudo blockdev --getss /dev/dasdf1
4096
$ sudo blockdev --getbsz /dev/dasdf1
4096

Since I always get confused by the internal 512 bytes vs. hard sector size vs. 
block size vs. file system block size I dont know if that is important.

Christian
