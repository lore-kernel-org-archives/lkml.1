Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYFZUfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYFZUfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbYFZUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:35:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYFZUf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:35:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Date: Thu, 26 Jun 2008 22:37:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806262237.15864.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 of June 2008, Joerg Roedel wrote:
> Hi,

Hi,

> this is the first post of the initial driver for AMD IOMMU hardware. The driver
> is tested on hardware with various loads (disk and network) and showed no
> problems.
> 
> It currently supports DMA remapping using the dma_ops API in the x86
> architecture code. It also supports isolation of device DMA address spaces as
> far as the hardware allows that (means each device can get its own DMA address
> space and can't access the DMA memory of other devices).
> 
> Please give this code a good review and send me your comments about it so that
> I can fix all possible bugs and objections and move this driver forward to
> merging quality.

Do you implement suspend/resume callbacks for the IOMMU and if so, which patch
in the series does introduce them?

Rafael
