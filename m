Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXCXRji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXCXRji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 13:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXCXRji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 13:39:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49007 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932500AbXCXRji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 13:39:38 -0400
Date: Sat, 24 Mar 2007 18:43:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Message-ID: <20070324184300.3250fab0@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 12:38:02 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Without NCQ, performance is MUCH better on almost every operation, with 
> the exception of 2-3 items.

It depends on the drive. Generally NCQ is better but some drive firmware
isn't too bright and there are probably still cases where we get bad
interactions in the kernel code that want tuning too
