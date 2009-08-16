Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZHPDCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZHPDCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 23:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZHPDCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 23:02:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:8887 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZHPDCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 23:02:11 -0400
From: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
To: Len Brown <lenb@kernel.org>
Subject: Re: Regression in ACPI in 2.6.31-rc5
Date: Sun, 16 Aug 2009 04:00:03 +0100
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-git9-17-default; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200908072333.24631.storm@sys49152.net> <alpine.LFD.2.00.0908122350560.22946@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908122350560.22946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908160400.03391.storm@sys49152.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Len Brown wrote:
> > I had two drivers stop working in 2.6.31 that were working fine in
> > 2.6.30. They are iwlagn and sky2. If i pass acpi=off to the kernel, they
> > work as expected.
>
> the bug report for this issue is here:
> http://bugzilla.kernel.org/show_bug.cgi?id=13940
>
> is it possible to bisect which commit between 2.6.30 and 2.6.31-rc5
> caused this regression?

git bisect tells me that commit 5d423ccd7ba4285f1084e91b26805e1d0ae978ed 
(x86/pci: remove rounding quirk from e820_setup_gap()) caused the problem.

I built a kernel based on HEAD with that commit reverted and both drivers 
work.

