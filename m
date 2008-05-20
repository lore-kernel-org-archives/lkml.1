Return-Path: <linux-kernel-owner+w=401wt.eu-S934537AbYETWD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbYETWD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934408AbYETWDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:03:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44404 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397AbYETWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:03:19 -0400
Date: Tue, 20 May 2008 23:03:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       bersace03@laposte.net, johannes@sipsolutions.de
Message-ID: <20080520220304.GA19116@srcf.ucam.org>
References: <20080520190628.GA14580@srcf.ucam.org> <200805202359.06873.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805202359.06873.oliver@neukum.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Firmware loader driver for USB Apple iSight camera
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:59:05PM +0200, Oliver Neukum wrote:

> How does that simplify suspend/resume?
> If the device looses its firmware due to suspend you must implement
> this support in uvc, or a user space driver will be as good as this solution.

If it loses its firmwrare, it'll reattach with the old ID.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
