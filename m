Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZBPQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZBPQuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZBPQuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:50:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:32910 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZBPQuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:50:11 -0500
Date: Mon, 16 Feb 2009 16:50:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpuinfo shows wrong MHz value
Message-ID: <20090216165008.GA8249@srcf.ucam.org>
References: <200902142217.51655.jplatte@naasa.net> <200902150800.59694.jplatte@naasa.net> <200902150811.36826.jplatte@naasa.net> <200902151741.30303.elendil@planet.nl> <loom.20090216T141158-818@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20090216T141158-818@post.gmane.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 02:19:50PM +0000, Thomas Renninger wrote:

> There should be a message when this driver is loaded like:
> "This driver is broken. Don't use it, don't complain."

Please don't. It's perfectly valid (if dumb) for machines to depend on 
the CPU for passive cooling even if they don't expose any P or T states. 
In that case p4-clockmod is the only code that can manage it. The 
removal of the user-visible cpufreq interface should be a strong enough 
hint that it's not intended for speed control.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
