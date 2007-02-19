Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXBSPQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXBSPQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXBSPQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:16:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXBSPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:16:03 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070219145613.GB75@tv-sign.ru> 
References: <20070219145613.GB75@tv-sign.ru>  <20070219115955.GB91@tv-sign.ru> <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com> <15331.1171890900@redhat.com> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 19 Feb 2007 15:15:46 +0000
Message-ID: <22137.1171898146@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Yes, destroy_nbp() does dev_put(dev). del_nbp() sets dev->br_port = NULL,
> port_carrier_check() goes to "done" in that case. So everething looks safe
> to me (but again, I do not even know what the "bridge" is :), so we should
> only take care about container, nothing more.

Sounds like a plan.

> I'll try to make a patch for illustration on evening.

:-)

David
