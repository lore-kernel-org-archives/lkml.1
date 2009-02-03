Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZBCKAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZBCKAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 05:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZBCKAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 05:00:04 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:50847 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZBCKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 05:00:03 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Tue, 3 Feb 2009 10:59:59 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902031034.12175.rjw@sisk.pl>
In-Reply-To: <200902031034.12175.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031059.59760.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2009 10:00:00.0375 (UTC) FILETIME=[2D2E4870:01C985E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Rafael J. Wysocki wrote:
> > What is different is that before this suspend I had switched to my
> > wired e1000e NIC and had done an ifdown on the wireless. I suspect
> > that because of that the wireless already was at D3 _before_ the
> > suspend was started.
>
> If ifdown causes the device to go into D3, then this is possible.

Note that I'm not 100% sure the device was in D3, but it seems likely.
All we really know is that it wasn't in D0.
