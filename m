Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZE2VcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZE2VcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZE2Vb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:31:56 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16428 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbZE2Vbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:31:55 -0400
Date: Fri, 29 May 2009 16:32:18 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, andrew.patterson@hp.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH v6] cciss: add cciss driver sysfs entries
Message-ID: <20090529213218.GA20102@beardog.cca.cpqcorp.net>
References: <20090413164524.17977.99322.stgit@bluto.andrew> <20090413164530.17977.32550.stgit@bluto.andrew> <20090528202124.GB4846@beardog.cca.cpqcorp.net> <20090529124813.689b7667.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529124813.689b7667.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 12:48:13PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 15:21:24 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > From: Andrew Patterson <andrew.patterson@hp.com>
> > 
> > This patch adds sysfs entries to the cciss driver needed for the
> > dm/multipath tools. A file for vendor, model, rev, and unique_id is
> > added for each logical drive under directory
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> > host) number and Y is the logical drive number. A link from
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> > /sys/block/cciss!cXdY/device is also created. A bus is created
> > in /sys/bus/cciss.  A link is created from the pci ccissX entry to
> > /sys/bus/cciss/devices/ccissX.
> > Please consider this for inclusion.
> > 
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> Did Andrew's signed-off-by: get lost?

No, I converted it into the From: field. Another screw up, I guess.

mikem
