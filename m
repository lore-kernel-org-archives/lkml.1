Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXGGXwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXGGXwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 19:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXGGXv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 19:51:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbXGGXv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 19:51:56 -0400
From: Andi Kleen <ak@suse.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 1/2] do_sys_poll: simplify playing with on-stack data
Date: Sun, 8 Jul 2007 01:51:05 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vadim Lobanov <vlobanov@speakeasy.net>, linux-kernel@vger.kernel.org
References: <20070707184802.GA193@tv-sign.ru>
In-Reply-To: <20070707184802.GA193@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707080151.05495.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007 20:48, Oleg Nesterov wrote:
> Cleanup. Lessens both the source and compiled code (100 bytes) and imho
> makes the code much more understandable.
>
> With this patch "struct poll_list *head" always points to on-stack
> stack_pps, so we can remove all "is it on-stack" and "was it initialized"
> checks.

Looks good.

-Andi
