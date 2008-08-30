Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYH3JQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYH3JQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbYH3JQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:16:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50378 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777AbYH3JQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:16:31 -0400
Date: Sat, 30 Aug 2008 09:59:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       p_gortmaker@yahoo.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ne.c msleep not mdelay
Message-ID: <20080830095906.6cad8647@lxorguk.ukuu.org.uk>
In-Reply-To: <20080830024453.GB24929@spacedout.fries.net>
References: <20080830024453.GB24929@spacedout.fries.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 21:44:53 -0500
David Fries <david@fries.net> wrote:

> mdelay(10) replaced by msleep(10) to give up the CPU, it's just
> waiting for an interrupt, so timing isn't critical.

It is too critical for a reschedule to occur.

NAK this one.
