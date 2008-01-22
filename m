Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYAVLqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYAVLqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 06:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYAVLqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 06:46:20 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:49379 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYAVLqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 06:46:19 -0500
Date: Tue, 22 Jan 2008 11:46:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com
Message-ID: <20080122114605.GA23983@srcf.ucam.org>
References: <20071226020325.GA21099@srcf.ucam.org> <1200990809.7424.31.camel@acpi-sony.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200990809.7424.31.camel@acpi-sony.sh.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 04:33:29PM +0800, Zhang Rui wrote:

> I have no obvious objection on either of these two proposals.
> But one thing to mention is that
> both of these two patches is written on the assumption that the
> brightness levels listed in _BCL method are in ascending order, while
> this is not stated in the ACPI spec.
> Is this a problem?

The driver already makes that assumption, and it's implicit in the spec.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
