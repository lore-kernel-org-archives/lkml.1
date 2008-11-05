Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYKEWLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYKEWLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYKEWLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:11:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYKEWK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:10:59 -0500
Subject: Re: bdi: register sysfs bdi device only once per queue
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, kay.sievers@vrfy.org,
       folkert@vanheusden.com, jacmet@sunsite.dk, linux-kernel@vger.kernel.org
In-Reply-To: <20081105121015.75f497d1.akpm@linux-foundation.org>
References: <1225727635.6009.9.camel@linux>
	 <1225728530.7803.1630.camel@twins>
	 <20081105121015.75f497d1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 23:10:40 +0100
Message-Id: <1225923040.3882.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 12:10 -0800, Andrew Morton wrote:
> > > Devices which share the same queue, like floppies and mtd devices,
> > > get registered multiple times in the bdi interface, but bdi accounts
> > > only the last registered device of the devices sharing one queue.
> > 
> > David, is there any reason the mtd devices do this?
> 
> [tap tap - is this thing turned on?]

No particular reason. It's been done that way since the dawn of time,
when it was perfectly normal. Nobody's yet bothered to change that, when
changing the rules.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

