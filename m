Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYHLU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYHLU3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYHLU3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:29:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYHLU3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:29:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200808122102.15794.ioe-lkml@rameria.de>
References: <200808122102.15794.ioe-lkml@rameria.de> <20080812132840.5472.25856.stgit@warthog.procyon.org.uk> <20080812132850.5472.5131.stgit@warthog.procyon.org.uk>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: dhowells@redhat.com, sfr@canb.auug.org.au, jmorris@namei.org,
       hch@infradead.org, davem@davemloft.net, sfrench@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] CRED: Introduce credential access wrappers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Tue, 12 Aug 2008 21:27:32 +0100
Message-ID: <9503.1218572852@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser <ioe-lkml@rameria.de> wrote:

> Why macros? When introducing APIs using trivial inlines makes sure that 
> the conversion is correct, type correct and side effect free for the callers.
> Macros cannot ensure this without pain.

But macros don't care that you can't access current at this point.

David
