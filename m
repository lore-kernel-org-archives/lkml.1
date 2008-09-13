Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYIMT4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYIMT4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYIMTzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:55:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52800 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYIMTzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:55:51 -0400
Message-ID: <48CC1ABC.3090903@garzik.org>
Date: Sat, 13 Sep 2008 15:55:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: Paul Gortmaker <paul.gortmaker@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ne.c Fix suspend and resume for ISA PnP cards.
References: <20080904030212.GA23493@spacedout.fries.net> <7d1d9c250809050101v9ab3907l649781ee38a5a243@mail.gmail.com> <20080909025434.GB28469@spacedout.fries.net> <20080909030114.GC28469@spacedout.fries.net>
In-Reply-To: <20080909030114.GC28469@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> From: David Fries <david@fries.net>
> 
> A call to pnp_stop_dev and pnp_start_dev now shuts down and
> initializes plug and play devices for suspend and resume.
> 
> Signed-off-by: David Fries <david@fries.net>
> Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---
>  drivers/net/ne.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ne.c b/drivers/net/ne.c
> index 2bece66..cd31e77 100644

applied


