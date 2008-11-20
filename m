Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYKTWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYKTWUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 17:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYKTWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 17:19:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36206 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYKTWTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 17:19:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com>
References: <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com>
To: "Hannes Eder" <hannes@hanneseder.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] CRED: fix compilation warning in function 'get_cred'
Date: Thu, 20 Nov 2008 22:19:31 +0000
Message-ID: <11321.1227219571@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder <hannes@hanneseder.net> wrote:

> Fix to following warning by introducing a temporary variable:
> 
> include/linux/cred.h: In function 'get_cred':
> include/linux/cred.h:187: warning: passing argument 1 of
> 'get_new_cred' discards qualifiers from pointer target type

Interesting.  I believe that's a compiler bug.  Explicitly casting away the
const should avoid this warning.

David
