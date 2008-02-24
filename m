Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYBXAup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYBXAup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYBXAui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:50:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53485 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751681AbYBXAuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:50:37 -0500
Date: Sun, 24 Feb 2008 01:50:38 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] macb: Fix speed setting
Message-ID: <20080224015038.3950a0de@siona>
In-Reply-To: <20080223000323.ac3eafa4.akpm@linux-foundation.org>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
	<1203612065-18192-1-git-send-email-hskinnemoen@atmel.com>
	<20080223000323.ac3eafa4.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 00:03:23 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 21 Feb 2008 17:41:05 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> 
> > From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > 
> > Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
> > conversion to generic PHY layer in kernel 2.6.23.  
> 
> So..  shouldn't we fix it in 2.6.23.x and 2.6.24.x?

Absolutely. I'll send it to the stable team after it hits mainline.

Haavard
