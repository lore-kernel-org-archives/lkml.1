Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbXGWSPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbXGWSPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXGWSPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:15:40 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:41798 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbXGWSPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:15:39 -0400
X-IronPort-AV: i="4.16,571,1175486400"; 
   d="scan'208"; a="35497278:sNHT28654542"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Date: Mon, 23 Jul 2007 14:19:12 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707182358.24984.rgetz@blackfin.uclinux.org> <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
In-Reply-To: <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231419.13182.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 23 Jul 2007 18:15:32.0808 (UTC) FILETIME=[7559C480:01C7CD55]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 22 Jul 2007 19:50, Mike Frysinger pondered:
>
> i think the attached two functions account for what Robin and Andrew
> were thinking ...

A note about why/when grab_lock would be set to zero (pre-kernel init, or 
OOPs) might be nice. 

Or - remove it - and tell people they should be using do_syslog interface in 
a "normal" kernel environment (where log_end or log_start can be updated).

Either would be fine with me. Andrew?

-Robin
