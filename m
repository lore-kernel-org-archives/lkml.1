Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbXIAWiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbXIAWiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbXIAWiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:38:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15209 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbXIAWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:38:04 -0400
Subject: Re: [PATCH 1/1] i386: fix a hang on stuck nmi watchdog
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: akpm@linux-foundation.org, eranian@hpl.hp.com, B.Steinbrink@gmx.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709012345.00991.ak@suse.de>
References: <20070901205417.305538884@mvista.com>
	 <200709012345.00991.ak@suse.de>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 15:27:30 -0700
Message-Id: <1188685651.11196.21.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 23:45 +0200, Andi Kleen wrote:
> On Saturday 01 September 2007 22:54:17 Daniel Walker wrote:
> > In the case when an nmi gets stucks the endflag stays equal to zero. This
> > causes the busy looping on other cpus to continue, even tho the nmi test
> > is done.
> > 
> > On my machine with out the change below the system would hang right after
> > check_nmi_watchdog(). The change below just sets endflag prior to checking
> > if the test was successful or not.
> > 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> Added thanks. I guess it's .23 material.

putting it in 2.6.23 seems appropriate .. Stephane's patch might be good
for 2.6.23 too .. 

Daniel

