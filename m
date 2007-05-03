Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbXECLL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbXECLL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXECLL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:11:27 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3118 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXECLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:11:23 -0400
Date: Thu, 3 May 2007 12:11:13 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
Message-ID: <20070503111113.GC12018@flint.arm.linux.org.uk>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 06:10:28AM -0400, Robert P. J. Day wrote:
> 
> $ ../dead_config.sh drivers/scsi
> ========== ACORNSCSI_CONSTANTS ==========
> drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
> drivers/scsi/arm/acornscsi.c:417:#ifdef CONFIG_ACORNSCSI_CONSTANTS
> drivers/scsi/arm/acornscsi.c:495:#ifdef CONFIG_ACORNSCSI_CONSTANTS
> ========== SCSI_ACORNSCSI_LINK ==========
> drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:1675:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:2849:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:2880:#ifdef CONFIG_SCSI_ACORNSCSI_LINK

False positives.  That #undef is preceded by a comment describing the
driver-internal configuration for developers rather than users.  I
guess they shouldn't be preceded by CONFIG_.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
