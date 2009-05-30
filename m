Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZE3J74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZE3J74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZE3J7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:59:49 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:49344 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbZE3J7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:59:48 -0400
Message-ID: <4A210389.80101@f2s.com>
Date: Sat, 30 May 2009 10:59:37 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@openedhand.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 1/5] MFD,mmc: tmio_mmc: make HCLK configurable
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com> <1243279681-4233-2-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1243279681-4233-2-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Ian Molton <spyro@f2s.com>

However I'd like to see the clk API  weaned of its CPU spcific 
dependencies so that it can be used for this purpose instead.

I consider ASIC3 support in this driver more important and this change 
is pretty noninvasive. Converting to the clk api in future shouldnt be 
any harder with this patch (actually slightly easier).

Philipp Zabel wrote:
> The Toshiba parts all have a 24 MHz HCLK, but HTC ASIC3 has a 24.576 MHz HCLK
> and AMD Imageon w228x's HCLK is 80 MHz. With this patch, the MFD driver
> provides the HCLK frequency to tmio_mmc via mfd_cell->driver_data.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Samuel Ortiz <sameo@openedhand.com>
> Cc: Pierre Ossman <pierre@ossman.eu>


