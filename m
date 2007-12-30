Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXL3CET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXL3CET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 21:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXL3CEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 21:04:12 -0500
Received: from usul.saidi.cx ([204.11.33.34]:50376 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751968AbXL3CEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 21:04:11 -0500
Message-ID: <4776FC8C.7080606@overt.org>
Date: Sat, 29 Dec 2007 18:03:56 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071121)
MIME-Version: 1.0
To: Sandeep K <san_kernel2008@yahoo.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: eMMC and MMC plus card supports
References: <546838.15392.qm@web45707.mail.sp1.yahoo.com>
In-Reply-To: <546838.15392.qm@web45707.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sandeep K wrote:
> Hi all,
> 
> Can anybody please let me know, does the current linux
> tree supports MMC plus and eMMC cards.

It certainly supports MMCplus. My understanding is that eMMC
is just a form-factor and is not visibly different to the host
controller, so it should just work. I know that the nokia n810
has an internal eMMC and it, obviously, works. They had some
odd issues with the Samsung part they're using and SET_BLOCK_COUNT
but I have no idea if that's an eMMC thing or specific to the part
they're using.

You also asked about "28bit lba" support in another email. I assume
you are asking about support for block addressed SDHC and MMCplus-HC cards.
The kernel supports both (although good luck trying to get a hold of an MMC
one).

Hope that helps,

--phil
