Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXI1Rfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXI1Rfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXI1Rfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:35:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52077 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbXI1Rfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:35:45 -0400
Date: Fri, 28 Sep 2007 10:35:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [13/17] Virtual compound page freeing in interrupt context
In-Reply-To: <20070928135255.80dd7575.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0709281035290.4883@schroedinger.engr.sgi.com>
References: <20070925234204.546836393@sgi.com> <20070925234252.220601640@sgi.com>
 <20070928135255.80dd7575.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, KAMEZAWA Hiroyuki wrote:

> On Tue, 25 Sep 2007 16:42:17 -0700
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > +static noinline void vcompound_free(void *addr)
> > +{
> > +	if (in_interrupt()) {
> 
> Should be (in_interrupt() || irqs_disabled()) ?

Maybe only irqs_disabled()?
