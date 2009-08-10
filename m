Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZHJOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZHJOza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZHJOz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:55:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57580 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZHJOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:55:28 -0400
Subject: Re: [PATCH 1/3] SCSI: Allow platform-specific code to be run
 against the SCSI tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
       shaohua.li@intel.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090810133815.GB22763@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
	 <20090810133815.GB22763@srcf.ucam.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 14:55:25 +0000
Message-Id: <1249916125.4089.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 14:38 +0100, Matthew Garrett wrote:
> On Mon, Jul 13, 2009 at 10:03:05PM +0100, Matthew Garrett wrote:
> > In certain cases (such as ACPI) we want to be able to associate
> > platform-specific data against the SCSI device tree. Handling this
> > properly requires the ability to run platform code at SCSI init time.
> > This patch adds stub functions that can be overridden if the platform
> > defines CONFIG_SCSI_PLATFORM.
> 
> James, any thoughts on this?

Sorry, I'd thought this had all moved to libata so I'd stopped paying
attention ... why are extra bits in SCSI necessary?

James


