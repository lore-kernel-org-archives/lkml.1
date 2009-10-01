Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbZJAIaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbZJAIaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbZJAIaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:30:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43559
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340AbZJAIaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:30:11 -0400
Date: Thu, 01 Oct 2009 01:30:30 -0700 (PDT)
Message-Id: <20091001.013030.98262804.davem@davemloft.net>
To: elendil@planet.nl
Cc: manty@manty.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910011026.17510.elendil@planet.nl>
References: <20090930110529.GA3676@dis.manty.net>
	<20090930235709.43ff1255.akpm@linux-foundation.org>
	<200910011026.17510.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Thu, 1 Oct 2009 10:26:14 +0200

> Question for IDE maintainers: should maybe the old printing of request info 
> be reinstated, or can the request flags also be obtained from the BUG 
> info?

Using a BUG for this doesn't make it any easier to track down the
problem.  WARN_ON_ONCE() or similar is much more appropriate here.

BUG() is for situations where the system's state is completely
irrecoverably corrupted, and we cannot continue, and that is not the
case here at all.
