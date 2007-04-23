Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXDWIdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXDWIdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXDWIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:33:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbXDWIdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:33:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070420212835.GA863@tv-sign.ru> 
References: <20070420212835.GA863@tv-sign.ru>  <20070420.015838.83621529.davem@davemloft.net> <29341.1176975158@redhat.com> <2969.1176992303@redhat.com> <1101.1177056127@redhat.com> <4713.1177065706@redhat.com> <20070420113805.c4877dc8.akpm@linux-foundation.org> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, ebiederm@xmission.com,
       containers@lists.osdl.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 23 Apr 2007 09:32:56 +0100
Message-ID: <1355.1177317176@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> We only care when del_timer() returns true. In that case, if the timer
> function still runs (possible for single-threaded wqs), it has already
> passed __queue_work().

Why do you assume that?

David
