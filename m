Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZHTUVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZHTUVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZHTUVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:21:06 -0400
Received: from bar.sig21.net ([80.81.252.164]:47671 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZHTUVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:21:05 -0400
Date: Thu, 20 Aug 2009 22:22:26 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #13946] x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090820202226.GA4444@sig21.net>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
 <ADSuNT6McuD.A.Rj.9NIjKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADSuNT6McuD.A.Rj.9NIjKB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.801,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 10:26:57PM +0200, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13946
> Subject		: x86 MCE malfunction on Thinkpad T42p
> Submitter	: Johannes Stezenbach <js@sig21.net>
> Date		: 2009-08-07 17:09 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=124966500232399&w=4
> Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/37908/

This is fixed in v2.6.31-rc6-223-g6c30c53 by
commit c7f6fa44115d401e89db730f357629d39f8e4ba6
"x86, mce: don't log boot MCEs on Pentium M (model == 13) CPUs".


Thanks
Johannes
