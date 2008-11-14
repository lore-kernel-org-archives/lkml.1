Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYKNAUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYKNAUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYKNAUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:20:25 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45931 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYKNAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:20:23 -0500
Date: Fri, 14 Nov 2008 00:20:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-pci@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] acpiphp: Call _LCK method
Message-ID: <20081114002022.GA18269@srcf.ucam.org>
References: <20081113235255.GA17709@srcf.ucam.org> <20081113235354.GB17709@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113235354.GB17709@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 11:53:54PM +0000, Matthew Garrett wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> Removable ACPI devices may have _LCK methods to indicate a software 
> controlled lock. These should be locked on device insertion and unlocked 
> when the user requests the device be ejected. Add support for flagging 
> devices with a _LCK method and then call appropriately on the add and 
> eject paths.

Please ignore this one - I've just realised it'll break on device 
reenumeration. The other patch in the series should be good, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
