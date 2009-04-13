Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbZDMVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbZDMVST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZDMVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:18:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53799 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZDMVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:18:04 -0400
Date: Mon, 13 Apr 2009 22:18:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
Message-ID: <20090413211800.GA17922@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org> <200904132128.54769.elendil@planet.nl> <20090413194341.GA16579@srcf.ucam.org> <200904132238.11401.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904132238.11401.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:38:09PM +0200, Frans Pop wrote:
> On Monday 13 April 2009, Matthew Garrett wrote:
> > Hm. Do you get events for the multimedia keys without this patch and
> > using the old interface?
> 
> Yes, 2.6.28 gives in /proc/acpi/toshiba/keys as value for 'hotkey':
> previous track:	0x0b31
> next track:	0x0b32
> play/pause:	0x0b33
> stop:		0x0b30

Without running any software, does hitting these keys cause the acpi 
interrupt in /proc/interrupts to increment?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
