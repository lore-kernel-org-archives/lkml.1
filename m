Return-Path: <linux-kernel-owner+w=401wt.eu-S966381AbXIBMzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966381AbXIBMzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965099AbXIBMz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:55:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41551 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016AbXIBMzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:55:25 -0400
Subject: Re: [PATCH 5/6] Use one zonelist that is filtered by nodemask
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0708311732580.19868@schroedinger.engr.sgi.com>
References: <20070831205139.22283.71284.sendpatchset@skynet.skynet.ie>
	 <20070831205319.22283.45590.sendpatchset@skynet.skynet.ie>
	 <Pine.LNX.4.64.0708311732580.19868@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 12:10:04 +0100
Message-Id: <1188731404.27508.0.camel@machina.109elm.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 17:34 -0700, Christoph Lameter wrote:
> Good idea. That gets rid of the GFP_THISNODE stuff that I introduced for 
> the memoryless node patchset.
> 

Yes, I was fairly pleased with that. It makes the split look a little
strange as an early patch makes it two zonelists and a later patch makes
it one. However, there didn't seem to be a nicer way of doing it without
having multi-purpose patches.

Thanks

-- 
Mel Gorman

