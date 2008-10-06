Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJFVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJFVcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYJFVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:32:11 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:26204 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753358AbYJFVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:32:11 -0400
Date: Tue, 7 Oct 2008 01:32:09 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081006213209.GA13072@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48EA77EF.6080502@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <48EA77EF.6080502@genesi-usa.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 03:41:19PM -0500, Matt Sealey wrote:
> There is a simple problem with the patch which is that an "IRQ 0" can and does
> actually exist on a bunch of platforms, at least to the best of my knowledge.
> 
> Checking for -1 (which means for definite, no irq at all, because it is
> totally unambiguous, as a -1 IRQ numbering is "impossible") is more correct.

This was discussed years ago.

http://lkml.org/lkml/2005/11/22/159
http://lkml.org/lkml/2005/11/22/227

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
