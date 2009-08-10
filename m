Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZHJNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZHJNiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZHJNiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:38:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57673 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbZHJNiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:38:18 -0400
Date: Mon, 10 Aug 2009 14:38:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, shaohua.li@intel.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] SCSI: Allow platform-specific code to be run
	against the SCSI tree
Message-ID: <20090810133815.GB22763@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247518987-10818-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 10:03:05PM +0100, Matthew Garrett wrote:
> In certain cases (such as ACPI) we want to be able to associate
> platform-specific data against the SCSI device tree. Handling this
> properly requires the ability to run platform code at SCSI init time.
> This patch adds stub functions that can be overridden if the platform
> defines CONFIG_SCSI_PLATFORM.

James, any thoughts on this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
