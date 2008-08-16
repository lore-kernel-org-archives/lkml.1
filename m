Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYHPUwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYHPUwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHPUvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:51:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45753 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYHPUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:51:51 -0400
Date: Sat, 16 Aug 2008 21:51:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, michael_e_brown@dell.com
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Message-ID: <20080816205145.GA4498@srcf.ucam.org>
References: <20080816202452.GA3331@srcf.ucam.org> <20080816202640.GB3331@srcf.ucam.org> <20080816203027.GC3331@srcf.ucam.org> <20080816134752.426bdd8a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816134752.426bdd8a@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 01:47:52PM -0700, Arjan van de Ven wrote:

> how does this interact with the backlight control done via ACPI ?

Dell's ACPI implementation appears to be implemented on top of this at a 
firmware level, so both are consistent. However, in terms of 
cleanliness, we should wait for Thomas's patches to be merged so this 
driver can disable the backlight support if there's an ACPI backlight 
present. The reason I implemented it is that there's no ACPI backlight 
support on some currently shipping Dells, never mind the older hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
