Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbXI1X66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbXI1X66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXI1X6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:58:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57034 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbXI1X6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:58:49 -0400
Date: Sat, 29 Sep 2007 08:58:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [13/17] Virtual compound page freeing in interrupt context
Message-Id: <20070929085857.acabb60f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0709281035290.4883@schroedinger.engr.sgi.com>
References: <20070925234204.546836393@sgi.com>
	<20070925234252.220601640@sgi.com>
	<20070928135255.80dd7575.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0709281035290.4883@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:35:44 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 28 Sep 2007, KAMEZAWA Hiroyuki wrote:
> 
> > On Tue, 25 Sep 2007 16:42:17 -0700
> > Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > +static noinline void vcompound_free(void *addr)
> > > +{
> > > +	if (in_interrupt()) {
> > 
> > Should be (in_interrupt() || irqs_disabled()) ?
> 
> Maybe only irqs_disabled()?
> 
Ah,.. maybe. 

-Kame
