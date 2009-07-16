Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbZGPUUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbZGPUUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbZGPUUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:20:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbZGPUUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:20:43 -0400
Date: Thu, 16 Jul 2009 16:20:29 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: regression post 2.6.30: device mapper fails on some logical
	volumes
Message-ID: <20090716202028.GA9005@redhat.com>
References: <200907151852.15121.borntraeger@de.ibm.com> <200907160736.09885.borntraeger@de.ibm.com> <20090716144438.GA8257@redhat.com> <200907161746.06935.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907161746.06935.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16 2009 at 11:46am -0400,
Christian Bornträger <borntraeger@de.ibm.com> wrote:

> Am Donnerstag 16 Juli 2009 16:44:39 schrieb Mike Snitzer:
> 
> I had another reproduce, and with the latest code (2.6.31-rc3) the mislignment  
> warnings from rc1 are indeed gone:

Ah OK, so you were using < 2.6.31-rc2 when you saw all those warnings.

> I now only have
> 
> [    6.283482] device-mapper: table: 253:51: dasdf1 too small for target
> [    6.283488] device-mapper: table: 253:51: dasde1 too small for target
> [    6.648895] device-mapper: table: 253:64: dasdc1 too small for target
> [    6.648900] device-mapper: table: 253:64: dasdd1 too small for target
> 
> The logical volumes space-test and space-home still dont appear.

I'm fairly certain that this pending fix will resolve your issues:
http://patchwork.kernel.org/patch/33534/

I'm not sure when Alasdair intends to push it to Linus but it should be
soon.

Mike
