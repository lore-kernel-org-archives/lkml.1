Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXLKRQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXLKRQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXLKRQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:16:22 -0500
Received: from gw.goop.org ([64.81.55.164]:32887 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXLKRQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:16:21 -0500
Message-ID: <475EC5E5.80104@goop.org>
Date: Tue, 11 Dec 2007 09:16:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: relax signature check
References: <9yY38-5oa-11@gated-at.bofh.it> <E1J27Or-00012X-DF@be1.7eggert.dyndns.org>
In-Reply-To: <E1J27Or-00012X-DF@be1.7eggert.dyndns.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Not BUG_ON(memcmp(xen_start_info->magic, "xen-3.", 6) != 0); ?
> I don't thin Xen version 32 will be compatible ...
>   

It had better be; if it loads the kernel, it should present a xen-3
compatible ABI.

But this is just a sanity check to make sure things are basically OK;
BUG_ON is hardly nice error reporting (not that there's much else we can
do at that point).

    J
