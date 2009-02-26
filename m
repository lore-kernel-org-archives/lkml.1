Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZBZBkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZBZBkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZBZBjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:39:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbZBZBjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:39:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <49A5E876.1000501@zytor.com>
References: <49A5E876.1000501@zytor.com> <49A5C754.7000408@zytor.com> <200902250452.UAA12902@hpdst41.cup.hp.com> <16693.1235565430@redhat.com> <7355.1235605851@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, Justin Chen <jchen@hpdst41.cup.hp.com>,
       linux-arch@vger.kernel.org, bjorn.helgaas@hp.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] bitops: Change the bitmap index from int to unsigned long [frv]
Date: Thu, 26 Feb 2009 01:37:48 +0000
Message-ID: <9679.1235612268@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> > But how does it break down between "static inline type\nfunction_name" and
> > "static inline\ntype function_name"?  That's more to the point.
> >
> 
> I believe that is the breakdown is roughly what you see above, i.e. over 8:1;
> the pattern I used was looking for "^static inline[^;(]*$", and a visual
> examination of the results shows that even if my line count is slighly off the
> lopsidedness is still dramatic.

Sorry, I meant:

"static inline type\nfunction_name" vs "static inline type function_name"

David
