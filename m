Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbXEGPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbXEGPwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934386AbXEGPwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:52:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934383AbXEGPwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:52:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1178543543.6158.7.camel@heimdal.trondhjem.org> 
References: <1178543543.6158.7.camel@heimdal.trondhjem.org>  <20070505164422.GD8975@stusta.de> <20070505014955.8f3990b5.akpm@linux-foundation.org> <15958.1178534871@redhat.com> <20070507105607.GB4226@stusta.de> 
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [-mm patch] fix fs/nfs/nfsroot.c compile error 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 07 May 2007 16:49:57 +0100
Message-ID: <20340.1178552997@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> It makes little or no sense to be forcing attributes like 'const' in a
> typedef. That is basically stating that it is inconceivable to use
> anything else. Clearly not the case here...

Yeah.  I think that there shouldn't be a typedef.  There's no real need for
it.

David
