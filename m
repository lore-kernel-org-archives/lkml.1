Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbXGYRgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbXGYRgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbXGYRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:36:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225AbXGYRgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:36:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070725172648.GH27237@ftp.linux.org.uk>
References: <20070725172648.GH27237@ftp.linux.org.uk> <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <20070725171956.GF27237@ftp.linux.org.uk> <46A786C7.9020604@zytor.com> 
To: Al Viro <viro@ftp.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Wed, 25 Jul 2007 18:35:43 +0100
Message-ID: <9602.1185384943@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:

> Where do you see passing &&<label> to assembly?  More interesting question
> is whether gcc believes it to be const...

Passing labels like that to assembly didn't used to work, which is a pity as
we could speed up things like get_user() if it could be made to.

David
