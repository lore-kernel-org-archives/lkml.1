Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbXGCFt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbXGCFt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXGCFtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:49:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:58030 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbXGCFtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:49:19 -0400
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
	pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 15:49:08 +1000
Message-Id: <1183441748.10386.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> a screaming nightmare - either the suspend fails because syslog (for 
> instance) can't be frozen, or the machine deadlocks for some other 
> reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> could do what we do for suspend to RAM on other platforms (PPC and APM) 
> and just not use the freezer.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

(And with much pleasure :-)

Cheers,
Ben.


