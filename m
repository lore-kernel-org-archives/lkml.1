Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142Ab0AAV41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0AAV41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800Ab0AAV40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:56:26 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60632 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0AAV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:56:26 -0500
Date: Fri, 1 Jan 2010 22:56:24 +0100
From: Andreas Mohr <andi@lisas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andreas Mohr <andi@lisas.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [PATCH] PCI / PM: Use per-device D3 delays
Message-ID: <20100101215624.GA16354@rhlx01.hs-esslingen.de>
References: <20100101170729.GA22252@rhlx01.hs-esslingen.de> <201001011955.27407.rjw@sisk.pl> <20100101201235.GA31960@rhlx01.hs-esslingen.de> <201001012242.28322.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001012242.28322.rjw@sisk.pl>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 10:42:28PM +0100, Rafael J. Wysocki wrote:
> On Friday 01 January 2010, Andreas Mohr wrote:
> > Then why is the value lower-bounded by pci_pm_d3_delay
> > (which, puzzlingly, was initialized to PCI_PM_D3_WAIT and thus 10
> > before, which the patch now removes!),
> 
> That's because dev->d3_delay is initialized to PCI_PM_D3_WAIT for all devices.

Doh, I should have viewn the altered mechanism correctly, sorry.
Seems quite correct and useful after all.

Andreas Mohr
