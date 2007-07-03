Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbXGCVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbXGCVhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXGCVhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:37:24 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:48381 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbXGCVhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:37:23 -0400
Date: Tue, 3 Jul 2007 22:36:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Message-ID: <20070703213639.GA29149@srcf.ucam.org>
References: <20070703211227.GA28758@srcf.ucam.org> <Pine.LNX.4.44L0.0707031713530.8010-100000@iolanthe.rowland.org> <20070703212002.GA28895@srcf.ucam.org> <200707032337.52544.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707032337.52544.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 11:37:51PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 3 July 2007 23:20, Matthew Garrett wrote:
> > We're used to the idea of applications blocking when a resource they're 
> > using goes away - NFS has done it forever. 
> 
> Now, please tell me how many driver writers even thought that something
> might try to access their devices after .suspend() had been executed (or
> even whilie it was being executed)?

Every single driver that fails under those conditions is already broken, 
and has been forever. It's likely that they're broken under run-time 
suspend, too.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
