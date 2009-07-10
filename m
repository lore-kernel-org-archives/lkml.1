Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZGJABz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZGJABz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZGJABr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:01:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44331 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924AbZGJABr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:01:47 -0400
Date: Fri, 10 Jul 2009 01:02:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anders Larsen <al@alarsen.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix sysrq caused USB performance regressions and
 leak
Message-ID: <20090710010245.17bd0958@lxorguk.ukuu.org.uk>
In-Reply-To: <1247154399l.14017l.2l@i-dmzi_al.realan.de>
References: <20090709123301.15654.4698.stgit@localhost.localdomain>
	<1247154399l.14017l.2l@i-dmzi_al.realan.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> shouldn't it be
> +	if (likely(!port->console || !port->sysrq))
> respectively
> +	if (unlikely(port->console && port->sysrq)) {
> 
> at least for clarity?

It'll get predicted by the CPU just fine I suspect.

Alan
