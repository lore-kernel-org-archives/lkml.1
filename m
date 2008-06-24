Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYFXKfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYFXKfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYFXKe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:34:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:33947 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYFXKe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:34:58 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200806232300.57614.bzolnier@gmail.com>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1214200453.8011.232.camel@pasglop> <1214203312.8011.246.camel@pasglop>
	 <200806232300.57614.bzolnier@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 20:34:53 +1000
Message-Id: <1214303693.8011.345.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Build error and/or your build fix would be useful here.

Sorry. Fix was a quick hack. There is a check_media_bay() followed by a
break; outside of a break-able construct in there (off memory, I'm not
in front of the dev box right now).

> Ok, I see the problem - we now need to clear dive->noprobe after
> ide_device_add() call (pmac.c) or later ide_port_scan() call (mediabay.c)
> will fail...  also there was a pmif->mediabay check missing...
> 
> Please try the new version of patch #1 (the other patches are unchanged):

Thanks. Will do ASAP tomorrow. I've been kept busy with other more
urgent things today (gotta love having meetings starting at 6AM in the
morning !)

Cheers,
Ben.


