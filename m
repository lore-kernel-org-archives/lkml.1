Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYBLVmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYBLVmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYBLVlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:41:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10861 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYBLVlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=wNGhvmHO9XiKqDWZv5uvc6PKUeqBfCeYCBWtu6grR7dogQDG0MhCxgJDtIFBubVHLvbw++307IT2CReMpOpPt57HefeGuTiYPUBbctWHtFZ3WzdVYC7qin5sMaTFkWo4m62wDn63YMc9CEAkMAnJ7PouwDic3h1sXmd7eOpc9l0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other goodies
Date: Tue, 12 Feb 2008 22:54:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <1202460043.7079.157.camel@pasglop> <1202850247.7410.24.camel@pasglop>
In-Reply-To: <1202850247.7410.24.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802122254.39663.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Benjamin Herrenschmidt wrote:
> 
> On Fri, 2008-02-08 at 19:40 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > - couple of fixes and preparatory patches
> > > 
> > > - rework of PowerMac media-bay support ([un]register IDE devices instead of
> > >   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]
> > 
> > Interesting... I was thinking about doing a full remove of the device at
> > a higher level instead but I suppose what you propose is easier.
> > 
> > I'll have a look & test next week hopefully.
> 
> Also, the above would have the advantage of not relying on drivers/ide
> infrastructure, and thus working with libata (once somebody has ported
> pmac ide to libata).

Neither of these things exist at the moment so lets stick to the existing
code which is scheduled for 2.6.26 and which finally allows removal of ppc
specific ide hacks from arch/{powerpc,ppc} (500 LOC gone, patches to be
posted this week), not to mention other nice changes in the future...

Thanks,
Bart
