Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYE0NxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYE0NxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYE0Nw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:52:56 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60545 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbYE0Nwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:52:55 -0400
Date: Tue, 27 May 2008 15:52:48 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: linux@maxim.org.za, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Filter out FP during baud rate detection
Message-ID: <20080527155248.1283eb58@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1211894683-20934-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1211894683-20934-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2008 13:52:42.0063 (UTC) FILETIME=[EEE5CDF0:01C8C000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> I made a change to u-boot that used the FP (Fractional Part) field of
> BRGR to achieve more accurate baud rate generation. Unfortunately, the
> atmel_serial driver looks at the whole BRGR register when trying to
> detect the baud rate that the port is currently running at, so setting
> FP to a nonzero value breaks the baud rate detection.
> 
> I'll sit on the u-boot patch for a while longer, but this is clearly a
> bug in the atmel_serial driver which should be fixed.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Oh, and before you ask: I think this should go into 2.6.26 and possibly
-stable as well. The sooner we get this into mainline, the sooner we
can start using fractional dividers in u-boot.

Haavard
