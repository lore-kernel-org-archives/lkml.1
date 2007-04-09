Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXDIQjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXDIQjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXDIQjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:39:39 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:55050 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXDIQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:39:38 -0400
Date: Mon, 9 Apr 2007 18:37:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Sandeen <sandeen@redhat.com>
cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
In-Reply-To: <4619B202.3050601@redhat.com>
Message-ID: <Pine.LNX.4.61.0704091835520.21426@yvahk01.tjqt.qr>
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8 2007 22:24, Eric Sandeen wrote:
> Samuel Thibault wrote:
>
> Can you elaborate?  Under what circumstances is log replay going to harm data?
> Do you mean that the installer mounts partitions, looking for what OS is
> installed?  How is that harmful?
>
> Hm, so the root cause there seems that the installer found 2 legs of a mirror
> and mounted them independently, recovering them independently... But why did
> that cause problems?

Because, for whatever unlikely reason there could possibly be, it may
have been repaired differently [depending on sunshine, daytime, rand(), 
or so]?


Jan
-- 
