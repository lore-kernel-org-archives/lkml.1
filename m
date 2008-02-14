Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbYBNVN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbYBNVN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbYBNVN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:13:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934418AbYBNVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:13:26 -0500
Date: Thu, 14 Feb 2008 22:49:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 4/4] kmemcheck v4
Message-ID: <20080214214907.GC19473@one.firstfloor.org>
References: <47B49DB2.2090402@gmail.com> <47B49E71.4040900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B49E71.4040900@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ifdefs are quite ugly. I would recommend to define standard
functions (kmemcheck_init_zero or similar and an own __GFP flag) that can 
be used without ifdef and easily nop'ed out on !KMEMCHECK kernels.

-Andi
