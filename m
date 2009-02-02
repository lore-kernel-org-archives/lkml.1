Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZBBQFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZBBQFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZBBQEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:04:55 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:60653 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZBBQEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:04:55 -0500
Date: Tue, 03 Feb 2009 01:04:58 +0900 (JST)
Message-Id: <20090203.010458.48796615.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: hskinnemoen@atmel.com, kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel-mci: fix initialization of dma slave data
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1233419203.5959.6.camel@dwillia2-linux.ch.intel.com>
References: <20090131.210651.126573837.anemo@mba.ocn.ne.jp>
	<20090131.235230.90118475.anemo@mba.ocn.ne.jp>
	<1233419203.5959.6.camel@dwillia2-linux.ch.intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 09:26:43 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> Subject: atmel-mci: fix initialization of dma slave data
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> The conversion of atmel-mci to dma_request_channel missed the
> initialization of the channel dma_slave information.  The filter_fn
> passed to dma_request_channel is responsible for initializing the
> channel's private data.  This implementation has the additional benefit
> of enabling a generic client-channel data passing mechanism.

Thank you.  It looks fine for me.

---
Atsushi Nemoto
