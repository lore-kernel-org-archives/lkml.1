Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbXGCMNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbXGCMNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXGCMNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:13:24 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:37393 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbXGCMNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:13:23 -0400
Date: Tue, 3 Jul 2007 13:13:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703121313.GA21318@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707030813.53481.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030813.53481.oliver@neukum.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 08:13:53AM +0200, Oliver Neukum wrote:

> Only if you want to audit all character devices' read() and write()
> methods for races against suspend().
> / on fuse is a bad idea.

Any driver that assumes that userspace will be frozen during suspend has 
been broken forever. That behaviour has never been guaranteed.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
