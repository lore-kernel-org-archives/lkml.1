Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbZHIQrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbZHIQrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZHIQrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:47:10 -0400
Received: from bar.sig21.net ([80.81.252.164]:39209 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZHIQrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:47:10 -0400
Date: Sun, 9 Aug 2009 18:47:18 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090809164718.GA16332@sig21.net>
References: <20090807170942.GB9177@sig21.net>
 <20090809100348.GA7186@sig21.net>
 <200908091234.04114.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908091234.04114.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.9 (---)
X-Spam-21-Report: No, score=-3.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.514,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 12:34:03PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 09 August 2009 12:03:48 Johannes Stezenbach wrote:
> > On Fri, Aug 07, 2009 at 07:09:42PM +0200, Johannes Stezenbach wrote:
> > > 
> > > I'm currently running linux-2.6.31-rc5-246-g90bc1a6 on
> > > an old Thinkpad T42p.  During boot I get the following:
> > ...
> > > 
> > > 2.6.29.1 doesn't log any MCE events, so I doubt this is a HW problem.
> 
> http://patchwork.kernel.org/patch/37908/

This patch fixes the issue for me.


Thanks,
Johannes
