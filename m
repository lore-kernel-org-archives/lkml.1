Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZHPKfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZHPKfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 06:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZHPKfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 06:35:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36176 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZHPKfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 06:35:03 -0400
Date: Sun, 16 Aug 2009 11:35:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.31-rc6] ACPI region conflict regression...
Message-ID: <20090816103503.GA3073@srcf.ucam.org>
References: <6278d2220908160259v38c34c4ck6db2853ae886492@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220908160259v38c34c4ck6db2853ae886492@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 10:59:38AM +0100, Daniel J Blueman wrote:

> Is there a way to relax this, or does it require adding
> acpi_bus_register_driver(struct acpi_driver) and the needed code this
> late in the game?

acpi_enforce_resources=lax

-- 
Matthew Garrett | mjg59@srcf.ucam.org
