Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYAWERq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYAWERq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYAWERi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:17:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:45418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYAWERh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:17:37 -0500
Subject: Re: [PATCH] ppc: fix #ifdef-s in mediabay driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <200801230158.42017.bzolnier@gmail.com>
References: <200801230012.38516.bzolnier@gmail.com>
	 <1201046394.6807.49.camel@pasglop>  <200801230158.42017.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 15:17:12 +1100
Message-Id: <1201061832.6807.64.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 01:58 +0100, Bartlomiej Zolnierkiewicz wrote:
> I'm more worried about breaking automatic build checking (make randconfig)
> than a few extra bytes so if you remove all #ifdefs you'll have to either
> make BLK_DEV_IDE_PMAC select PMAC_MEDIABAY or make PMAC_MEDIABAY depend
> on BLK_DEV_IDE_PMAC (otherwise BLK_DEV_IDE=n && PMAC_MEDIABAY=y will fail
> since mediabay.c is referencing IDE code).

I was thinking about having the pmac arch code provide an exported
function pointer to put the hook in to avoid that problem.

Ben.


