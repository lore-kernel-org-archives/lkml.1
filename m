Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZAURWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZAURWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZAURW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:22:28 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:51503 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbZAURW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:22:28 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING: at drivers/pci/pci-driver.c:368 pci_legacy_suspend+0x7b/0xb8()
Date: Wed, 21 Jan 2009 18:20:04 +0100
User-Agent: KMail/1.9.9
References: <200901211414.18009.elendil@planet.nl> <200901211709.35242.rjw@sisk.pl>
In-Reply-To: <200901211709.35242.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, philipl@overt.org,
       "Pierre Ossman" <drzeus@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211820.05325.elendil@planet.nl>
X-OriginalArrivalTime: 21 Jan 2009 17:22:22.0149 (UTC) FILETIME=[D1F0D750:01C97BEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Rafael J. Wysocki wrote:
> the warning is very much on purpose.  The ricoh_mmc driver appears to
> do a bad thing here (powering down the device without saving its state)
> and that causes the warning to trigger.
>
> Please check if this patch makes the warning go away:
> http://marc.info/?l=linux-kernel&m=123230574110042&w=4

Gah! And I was even aware that patch existed...
Adding that patch does indeed make the warning go away.

Thanks Rafael.
