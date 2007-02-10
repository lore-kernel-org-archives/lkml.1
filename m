Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbXBJDmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbXBJDmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 22:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXBJDmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 22:42:24 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:56643 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbXBJDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 22:42:24 -0500
Date: Sat, 10 Feb 2007 03:42:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <20070210034210.GB16490@srcf.ucam.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171058269.1484.64.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: NAK new drivers without proper power management?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 08:57:49AM +1100, Nigel Cunningham wrote:

> Can we start to NAK new drivers that don't have proper power management
> implemented? There really is no excuse for writing a new driver and not
> putting .suspend and .resume methods in anymore, is there?

The PCI layer is able to deal with drivers that have no PM methods in 
the most simple case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
