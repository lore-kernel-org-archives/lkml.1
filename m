Return-Path: <linux-kernel-owner+w=401wt.eu-S935024AbYGCHLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024AbYGCHLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYGCG6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:40478 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYGCFeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:34:01 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200806261140.39531.bzolnier@gmail.com>
References: <200806162124.43005.bzolnier@gmail.com>
	 <200806261051.34733.bzolnier@gmail.com> <1214470868.8011.455.camel@pasglop>
	 <200806261140.39531.bzolnier@gmail.com>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 15:33:56 +1000
Message-Id: <1215063236.21182.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > That's ok, just tell me a tree and an SHA1 ID of a commit on top of
> > which they apply, that will make my life easier :-)
> 
> They are still for *linux-next* (since they depend on other IDE changes)
> and apply fine on top of -20080625.
> 
> SHA1 ID is: 9ab50ba2f4958b593802ce91395d07148b611b71 but I don't know
> whether it is useful in linux-next context.

Took me a while, kid was sick.

They apply on 20080625 (with various offset/fuzz but they do apply) and
the tree builds. The media bay however fails the same way as before with
IDE register errors.

I'll see if I can find where they come from.

Ben.


