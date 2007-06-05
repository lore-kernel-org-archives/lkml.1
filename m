Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbXFELzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbXFELzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXFELza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:55:30 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:42827 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbXFELz3 (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:55:29 -0400
Date: Tue, 5 Jun 2007 12:55:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: James Jarvis <James.Jarvis@ed.ac.uk>, Riley@Williams.Name,
       Linux-Kernel@vger.kernel.org, graham.newton@ed.ac.uk,
       kenneth.macdonald@ed.ac.uk
Message-ID: <20070605115521.GA10634@srcf.ucam.org>
References: <fa./cH7AY3hv2QMikoTK1P7fAVvbdI@ifi.uio.no> <4664B306.5000107@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4664B306.5000107@shaw.ca>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes hang on reboot
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 06:49:10PM -0600, Robert Hancock wrote:

> This blacklist seems to be growing. Isn't there something better we can 
> do here? Can we just reboot through the BIOS by default, is that really 
> broken on some systems?

Yes, that breaks a separate set of machines. It would be interesting to 
try resetting just by banging the keyboard controller from userspace, 
and seeing if that fails in the same way - I suspect that on certain 
hardware, part of the shutdown process confuses it in some way.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
