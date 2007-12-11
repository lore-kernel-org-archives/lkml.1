Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbXLKPw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbXLKPw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXLKPwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:52:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLKPwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:52:19 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] xen: relax signature check
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Reply-To: 7eggert@gmx.de
Date: Tue, 11 Dec 2007 16:52:01 +0100
References: <9yY38-5oa-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J27Or-00012X-DF@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/q6RTTM8pxJ0ota5kFVPQDVkOj8OcCmr0SI6j
 duE4Wflrnw0OfL4Wls0FLCAh9Az6EpAJAKhYJStm34QTYPpRwK
 +8eXUDnkME54sQWKfdkZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Some versions of Xen 3.x set their magic number to "xen-3.[12]", so
> relax the test to match them.


> -     BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);
> +     BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);

Not BUG_ON(memcmp(xen_start_info->magic, "xen-3.", 6) != 0); ?
I don't thin Xen version 32 will be compatible ...

