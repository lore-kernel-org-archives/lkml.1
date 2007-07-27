Return-Path: <linux-kernel-owner+w=401wt.eu-S935166AbXG0KPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935166AbXG0KPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbXG0KPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:15:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbXG0KPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:15:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200707270944.LAA17167@ifs.emn.fr>
References: <200707270944.LAA17167@ifs.emn.fr>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 27 Jul 2007 11:14:57 +0100
Message-ID: <22618.1185531297@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoann Padioleau <padator@wanadoo.fr> wrote:

> When comparing a pointer, it's clearer to compare it to NULL than to 0.

Can you make them of style:

	if (!x)

instead?

Thanks,
David
