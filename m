Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXJVOyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXJVOyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXJVOyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:54:31 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:34933 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXJVOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:54:30 -0400
Date: Mon, 22 Oct 2007 15:54:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: John Belmonte <john@neggie.net>
Cc: Jonathan McDowell <noodles@earth.li>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20071022145415.GA4912@srcf.ucam.org>
References: <20071021173529.GH1880@earth.li> <471C88E2.3020102@neggie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471C88E2.3020102@neggie.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Add bluetooth support to toshiba-acpi driver
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:26:26AM -0400, John Belmonte wrote:

> The /proc/acpi/toshiba interface should not be expanded-- do not apply
> this patch.  If any patch is applied, it would be to optionally
> implement the generic /dev/toshiba interface so that user space tools
> like toshset can operate.

The correct interface is rfkill, which will require this functionality 
to be in-kernel anyway. I can see the argument against implementing it 
in /proc/acpi/toshiba (further proc interface bloat), but not against 
doing it in-kernel. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
