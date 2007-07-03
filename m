Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXGCFVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXGCFVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXGCFVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:21:41 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45465 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXGCFVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:21:40 -0400
Date: Tue, 3 Jul 2007 06:21:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703052130.GA17605@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031454.42078.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031454.42078.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 02:54:41PM +1000, Nigel Cunningham wrote:

> Note, though, that this won't help at all when people use the "suspend-to-ram 
> instead of powering down after writing a hibernation image" feature in 
> (uswsusp | tuxonice). Fuse is just a broken idea in the first place, but 
> given that it exists, we still need to find the underlying cause.

If / is on fuse it's unlikely that hibernation is high on your list of 
priorities right now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
