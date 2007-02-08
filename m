Return-Path: <linux-kernel-owner+w=401wt.eu-S1161429AbXBHDxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161429AbXBHDxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161472AbXBHDxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:53:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:47676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161429AbXBHDxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:53:03 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Date: Wed, 7 Feb 2007 22:51:42 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200702080055.33939.a1426z@gawab.com>
In-Reply-To: <200702080055.33939.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702072251.42413.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 February 2007 16:55, Al Boldi wrote:
> Len Brown wrote:
> > ACPICA Core version 2070126 simplifies the ACPI table manager
> > code by consolidating multiple table definitions into one.
> > It also saves memory by mapping the tables where the BIOS provides them
> > rather than copying them into the kernel.
> 
> Thanks for the update, but does it fix the ISA VGA STR-regression in 2.6.20?

Unlikely.
But I'm not aware of an ISA VGA STR-regression in 2.6.20, so I can't really say.
In general, VGA STR issues are related to the BIOS and video drivers
and have nothing to do with ACPI support itself.

> Also, is there some dependency that requires a display card to be present for 
> STR to work?

ACPI doesn't care if you have VGA or not.

-Len
