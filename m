Return-Path: <linux-kernel-owner+w=401wt.eu-S1751195AbZL0Xek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbZL0Xek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZL0Xej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:34:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59242 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZL0Xej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:34:39 -0500
Date: Mon, 28 Dec 2009 00:34:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] [6/6] kfifo: Document everywhere that size has to be
	power of two
Message-ID: <20091227233438.GB2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <20091227210316.B116EB17C3@basil.firstfloor.org> <1261950632.25298.33.camel@wall-e> <20091227221438.GA16353@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227221438.GA16353@core.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 02:14:38PM -0800, Dmitry Torokhov wrote:
> On Sun, Dec 27, 2009 at 10:50:32PM +0100, Stefani Seibold wrote:
> > Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > > On my first try using them I missed that the fifos need to 
> > > be power of two, resulting in a runtime bug. Document that requirement
> > > everywhere (and fix one grammar bug)
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > 
> > 
> > Acked: Stefani Seibold <Stefani@Seibold.net>
> > 
> 
> Now, does it really _have_ to be this way? For record-oriented
> FIFO's it is customary to be 2*pow(n)*sizeof(rec) which is rarely
> 2*pow(m).

Yes I agree, but the kfifos are not fully record oriented unfortunately.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
