Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXEGKuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXEGKuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXEGKuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:50:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbXEGKuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:50:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070505164422.GD8975@stusta.de> 
References: <20070505164422.GD8975@stusta.de>  <20070505014955.8f3990b5.akpm@linux-foundation.org> 
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [-mm patch] fix fs/nfs/nfsroot.c compile error 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 07 May 2007 11:47:51 +0100
Message-ID: <15958.1178534871@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> match_table_t was made "const" and gcc doesn't like "const __initdata":

Hmmm...  My gcc seems quite happy with it.  What gcc are you using?

Shouldn't __initdata override const?

> BTW: Why is this change to include/linux/parser.h in the net tree?

Because DaveM picked it up as part of my AFS patches, I guess.

David
