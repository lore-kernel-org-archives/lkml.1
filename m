Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbXGXUJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbXGXUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXGXUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:09:21 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15388 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbXGXUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:09:20 -0400
X-IronPort-AV: i="4.16,575,1175486400"; 
   d="scan'208"; a="35592535:sNHT22962849"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: early_printk accessing __log_buf
Date: Tue, 24 Jul 2007 16:12:56 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707241350.45086.rgetz@blackfin.uclinux.org> <20070724111215.8d91dc7c.akpm@linux-foundation.org>
In-Reply-To: <20070724111215.8d91dc7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241612.56509.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Jul 2007 20:09:15.0772 (UTC) FILETIME=[829133C0:01C7CE2E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24 Jul 2007 14:12, Andrew Morton pondered:
> Oh well, it sounds like we need the super-duper fast version.  Keep it
> as simple as possible, please.

What about:

int log_buf_copy(void *dest, int idx, size_t n);

starting at index idx - copy n bytes to dest, return the number of bytes 
copied (in case there are not n bytes in the log_buf yet).
