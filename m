Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZDORE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZDORE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZDOREU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:04:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZDORET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:04:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1239813627.7443.18.camel@pasglop>
References: <1239813627.7443.18.camel@pasglop> <20090414155651.27671.36394.stgit@warthog.procyon.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: dhowells@redhat.com, linux-fbdev-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make radeon_reinitialize_M10() absent if its reference is #ifdef'd out
Date: Wed, 15 Apr 2009 18:03:06 +0100
Message-ID: <21910.1239814986@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Nah. You ifdef it with CONFIG_PPC_PMAC, but it can be used on x86
> too (see the "BUGFIX" entries).

Ah...  I missed those:-(

David
