Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYFCADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYFCADo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYFCADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:03:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbYFCADg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:03:36 -0400
Date: Mon, 2 Jun 2008 17:03:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: bjorn.helgaas@hp.com, torvalds@linux-foundation.org, avuton@gmail.com,
       rene.herman@gmail.com, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
Message-Id: <20080602170309.6f9aea47.akpm@linux-foundation.org>
In-Reply-To: <48448932.80803@keyaccess.nl>
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
	<200806021605.14519.bjorn.helgaas@hp.com>
	<3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>
	<200806021642.50491.bjorn.helgaas@hp.com>
	<20080602164954.2aff2d77.akpm@linux-foundation.org>
	<48448932.80803@keyaccess.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 01:58:42 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 03-06-08 01:49, Andrew Morton wrote:
> 
> > This broke
> > pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch:
> 
> I expect the patch was meant solely for 2.6.26...

Sure.  When this patch
(pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch) is
applied to 2.6.26, the for-2.6.27
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
broke, as I described here.

> Bjorn, before you repost the option series due to this, wait a minute. 
> Am now looking at/testing 14/15 and see some stuff that needs changing 
> as well.

"the option series" == "PNP: convert resource options to unified
dynamic list, v1".

I haven't got onto that yet.  Strategic lagginess is working out
nicely.
