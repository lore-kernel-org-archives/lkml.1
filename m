Return-Path: <linux-kernel-owner+w=401wt.eu-S1422765AbXCWKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422765AbXCWKFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422772AbXCWKFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:05:46 -0400
Received: from eazy.amigager.de ([213.239.192.238]:58965 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422765AbXCWKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:05:45 -0400
Date: Fri, 23 Mar 2007 11:05:43 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Message-ID: <20070323100543.GA10926@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <eto9sh$262$1@sea.gmane.org> <1174485863.10840.80.camel@localhost.localdomain> <200703221134.52481.marcus@better.se> <eu05p3$u20$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eu05p3$u20$1@sea.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 10:14:11 +0100, Marcus Better wrote:
> Marcus Better wrote:
> > The XFS workqueue patch [1] fixes my problem [2].
> 
> > [1] http://permalink.gmane.org/gmane.linux.kernel/507616
> > [2] http://permalink.gmane.org/gmane.linux.kernel/505570
> 
> Unfortunately it only fixed suspend to RAM. Suspend to disk still hangs
> at "snapshotting system". Will try to bisect it...

I don't know if this is related, but using 2.6.21-rc4 and suspend2
2.2.9.7, I also get a hang at suspend. I could try if this also happens
with 2.6.20 and the same suspend2 version.

Regards,
Tino

