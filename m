Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZFWKrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZFWKrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZFWKrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:47:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46258
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbZFWKrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:47:39 -0400
Date: Tue, 23 Jun 2009 03:47:43 -0700 (PDT)
Message-Id: <20090623.034743.158192924.davem@davemloft.net>
To: elendil@planet.nl
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906222101.38586.elendil@planet.nl>
References: <200906221716.05983.elendil@planet.nl>
	<200906221938.27574.bzolnier@gmail.com>
	<200906222101.38586.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Mon, 22 Jun 2009 21:01:37 +0200

> The question is maybe: are there other devices that currently have dma 
> disabled because of the (old) code and would stop working with 
> ide_id_dma_bug() completely removed? The conservative thing to do I guess 
> would be to reverse 8d64fcd9.

For this specific situation I would likely avoid a revert at least
with how things currently stand.

Right now we are not yet certain what introduced the problem.

We are also not certain what might break by reverting this commit,
either.  There are portions of that commit other than the one
changing the logic of ide_id_dma_bug().

That's a "fix" based upon two large unknowns, which is not wise I
think :)
