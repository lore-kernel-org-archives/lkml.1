Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbYBYWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbYBYWIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbYBYWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:08:08 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:45616 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbYBYWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:08:07 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
Date: Tue, 26 Feb 2008 00:09:46 +0200
User-Agent: KMail/1.9.7
References: <200802252237.12326.mitov@issp.bas.bg> <200802252336.06498.mitov@issp.bas.bg> <20080225134216.7704696d@extreme>
In-Reply-To: <20080225134216.7704696d@extreme>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260009.46487.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Make sure the interrupt is showing up as level triggered in
> /proc/interrupts. The BIOS may be configuring it as edge-triggered and that
> won't work with Ethernet drivers that use NAPI.

for: skge <--> Marvell 88E8001 chip
cat /proc/interrupts gives (AMD64 X2 SMP):
           CPU0       CPU1
 21:   11691000   11933174   IO-APIC-fasteoi   eth0

It is neither IO-APIC-edge, nor IO-APIC-level.

Could it be the problem?

Marin Mitov


