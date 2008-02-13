Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYBMImA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYBMImA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYBMIlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:41:52 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:54485 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYBMIlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:41:51 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Date: Wed, 13 Feb 2008 09:41:46 +0100
User-Agent: KMail/1.9.7
References: <200802111623.38478.elendil@planet.nl>
In-Reply-To: <200802111623.38478.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802130941.47163.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 08:41:47.0576 (UTC) FILETIME=[44FEFB80:01C86E1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008, Frans Pop wrote:
> In general 2.6.25 if looking quite good on my desktop, but there's one
> important issue: the system no longer powers off after shutdown.
> This works fine with 2.6.24.

I was wrong :-(

I'd not really done any real workkkk under 2.6.25 yet, but now while running 
a kernel compile with -j4 (single processor, dual core Pentium D), I see 
this behavior. The mouse cursor moves a bit jerky and I sometimes get key 
presses repeated.

While I'm typing this, the load lowers a bit and immediately things become 
smoother and the key repeats seem to vanish.

(The key repeats in the subject and para above are real examples of this, 
not typo's.)

The keyboard repeat issue looks like what was reported in [1], but for me 
this is very definitely an new issue that did not appear with 2.6.24 or 
earlier.

Cheers,
FJP

[1] http://lkml.org/lkml/2008/2/6/100
