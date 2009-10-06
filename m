Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbZJFWgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbZJFWgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZJFWgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:36:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348AbZJFWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:36:10 -0400
Date: Tue, 6 Oct 2009 15:35:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>, Joao Ramos <joao.ramos@inov.pt>,
       David Fries <david@fries.net>, d.stussy@yahoo.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] two ide fixes for -rc4
In-Reply-To: <200910070027.30377.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.01.0910061534040.3432@localhost.localdomain>
References: <200910070027.30377.bzolnier@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David, can you test these on the sis5513 system that had problems with the 
original pio0 mode setting?

	Thanks,
		Linus

On Wed, 7 Oct 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> patch #1 fixes old bug in sis5513 (uncovered by 2.6.30 device probing
> changes but it could be also triggered in earlier kernels on warm-plug
> operation)
> 
> patch #2 reverts the recent incorrect revert
> 
