Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZFTSvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZFTSvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZFTSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:48:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146AbZFTSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:48:51 -0400
Date: Sat, 20 Jun 2009 14:48:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
Message-ID: <20090620184846.GA24550@infradead.org>
References: <1245249469.5982.251.camel@desktop> <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop> <4A391A54.7000109@goop.org> <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com> <1245274308.5982.268.camel@desktop> <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com> <1245451983.32124.25.camel@desktop> <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com> <1245458940.32124.45.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245458940.32124.45.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 05:49:00PM -0700, Daniel Walker wrote:
> Most of these questions related to the fact that I don't think an
> interface like this just slips into the kernel as a driver. Since it's
> IPC, it's totally generic, and it's not part of a standard (i.e. POSIX),
> we need to have some better and more specific information about it (or
> atleast I do). 

It's in the crap^H^H^H^Hstaging tree and might for all practivcal
purposes not exist.  The binders interface as implemented currently with
it's fdtable munging and messing around with the user virtual address
space has exactly zero chance to go properly upstream.

