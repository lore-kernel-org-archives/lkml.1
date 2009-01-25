Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZAYWsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZAYWsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZAYWsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:48:14 -0500
Received: from kroah.org ([198.145.64.141]:41084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbZAYWsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:48:13 -0500
Date: Sun, 25 Jan 2009 14:18:57 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] consolidate driver_probe_done() loops into one
	place
Message-ID: <20090125221857.GA18543@kroah.com>
References: <20090109211346.3ccc36e3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109211346.3ccc36e3@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 09:13:46PM -0800, Arjan van de Ven wrote:
> From 11b47973023398ecdb933c442bab120906946762 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 9 Jan 2009 21:04:53 -0800
> Subject: [PATCH] consolidate driver_probe_done() loops into one place
> 
> there's a few places that currently loop over driver_probe_done(), and
> I'm about to add another one. This patch abstracts it into a helper
> to reduce duplication.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Do you need me to take this through my tree?  Or is it going through the
acpi tree?

thanks,

greg k-h
