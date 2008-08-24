Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYHXGSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYHXGSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 02:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHXGSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 02:18:42 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:36785 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbYHXGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 02:18:41 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11379] char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Sun, 24 Aug 2008 08:18:08 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.RSH.faGsIB@albercik>
In-Reply-To: <VSpL6AnBTS.A.RSH.faGsIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808240818.09275.elendil@planet.nl>
X-OriginalArrivalTime: 24 Aug 2008 06:18:39.0333 (UTC) FILETIME=[3FBAD950:01C905B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11379
> Subject	: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-08-18 13:40 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=121906698213329&w=4
> Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>

Fixed with:
commit 5e4c6564c95ce127beeefe75e15cd11c93487436
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Thu Aug 21 15:28:56 2008 +0200

    pnp: fix "add acpi:* modalias entries"
