Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXEIW47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXEIW47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXEIW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:56:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55305 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXEIW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:56:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46425195.9030501@s5r6.in-berlin.de>
Date: Thu, 10 May 2007 00:56:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org> <464237A9.6060301@redhat.com> <464243C8.8090503@s5r6.in-berlin.de> <4642477A.3000801@redhat.com>
In-Reply-To: <4642477A.3000801@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> This mean we have to add all the LUs from the unit directory
> corresponding to the sbp2_device struct to that host.  Is that
> a problem?

Most certainly not for now.

> I think we had this discussion before,

I believe that was on a different aspect of multi-LU targets.

> but I still don't understand why this approach isn't feasible. 

I didn't say it was infeasible.  On the contrary, I too wanted (am
wanting) to rework sbp2 so that it instantiates only a single
Scsi_Host globally or per FireWire initiator port.  It's just one
of the things that I always pushed back, and where the devil is in
the detail.  (Notably if multiple targets, not just multiple LUs
of one target, live beneath one Scsi_Host.)
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/
