Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYIIQBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYIIQBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYIIQBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:01:35 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:34434 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013AbYIIQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:01:34 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] e100: Use pci_pme_active for clearing wake-up events and disabling PME#
Date: Tue, 9 Sep 2008 18:01:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, kernel-testers@vger.kernel.org,
       jesse.brandeburg@intel.com, Andrew Morton <akpm@linux-foundation.org>
References: <200809090812.37649.elendil@planet.nl> <200809091514.23817.rjw@sisk.pl>
In-Reply-To: <200809091514.23817.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091801.31732.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2008 16:01:31.0897 (UTC) FILETIME=[539C9E90:01C91295]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008, Rafael J. Wysocki wrote:
> The appended patch should fix the problem (ISTR sending it some time
> ago already).

Patch works for me.

Thanks Rafael!

> e100: Use pci_pme_active for clearing wake-up events and disabling PME#
>
> Currently e100 uses pci_enable_wake() to clear pending wake-up events
> and disable PME# during intitialization, but that function is not
> suitable for this purpose, because it immediately returns error code
> if device_may_wakeup() returns false for given device.
>
> Make e100 use pci_pme_active(), which carries out exactly the
> required operations, instead.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Frans Pop <elendil@planet.nl>
