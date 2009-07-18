Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbZGRFCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbZGRFCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 01:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZGRFCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 01:02:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45576 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZGRFCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 01:02:37 -0400
Date: Sat, 18 Jul 2009 06:02:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] libata: Export AHCI capabilities
Message-ID: <20090718050233.GA18236@srcf.ucam.org>
References: <1247854427-3315-1-git-send-email-mjg@redhat.com> <4A61544B.5030403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A61544B.5030403@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 10:49:15PM -0600, Robert Hancock wrote:

> Surely there's a better format for exporting this information to  
> userspace than making it parse out the bits from the raw register  
> contents.. how about separate sysfs files for ESP, HPCP, etc? Or  
> something more abstracted at a higher level that other drivers (if they  
> have access to similar information) could use?

I could split out more of the information, but there's a balance between 
exposing enough that we won't need to add more values in the near future 
and ending up with one sysfs file for pretty much every capabilities 
bit. I'm not aware of any cases where we can currently generalise this 
to other controllers, but I'm happy to be proven wrong on that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
