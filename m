Return-Path: <linux-kernel-owner+w=401wt.eu-S938723AbXFHMiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938723AbXFHMiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937232AbXFHMiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:38:15 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:33247 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937562AbXFHMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:38:14 -0400
Date: Thu, 7 Jun 2007 23:44:21 -0400
From: Kyle McMartin <kyle@canonical.com>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
Message-ID: <20070608034421.GM26717@fattire.cabal.ca>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:05:34PM +0200, Christoph Pleger wrote:
> So, my question is the follwing: Is it an expected feature that the file
> sizes of modules grow so much only because of a different cpu type and a
> different localversion, or is there probably a bug in my build tools?
> 

The kernel is compiled with debug info so that we can strip it later to
build two packages, one with debugging information intact, and one
without it.

If you disable CONFIG_DEBUG_KERNEL, things should go back to normal
sizes for you.

Regards,
	Kyle M.
