Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYKTO1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYKTO1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbYKTO0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:26:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39486 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbYKTO0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:26:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1224017504.8907.42.camel@localhost>
References: <1224017504.8907.42.camel@localhost> <20081014120753.7f968845.akpm@linux-foundation.org> <20081008232237.GH14527@fieldses.org> <1228.1224016436@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, jmorris@namei.org
Subject: Re: nfsd 2.6.28 merge plans
Date: Thu, 20 Nov 2008 14:25:55 +0000
Message-ID: <10442.1227191155@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> I'm happy with the changes that you made after the plumbers conf, so as
> far as the NFS side of the patches is concerned, we should be close to
> ready to merge.

Okay...  I've fixed a couple of bugs and now it seems to survive multiple
parallel tars being repeatedly thrown at it.

How do you want to do this?  I could make a GIT tree for you to pull, but it'd
have to be based on James Morris's next branch for the security features
required.

Alternatively, I could supply you with patches or a GIT tree, including the
security patches based on Linus's tree rather than James's.

Or we could wait until after the next merge window and hope Linus pulls them
this time (which he ought to, via James's tree).

David
