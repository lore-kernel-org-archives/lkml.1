Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZBTMLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZBTMLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBTMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:11:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZBTMLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:11:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090219161211.9b80c129.akpm@linux-foundation.org>
References: <20090219161211.9b80c129.akpm@linux-foundation.org> <20090212104000.26766.11068.stgit@warthog.procyon.org.uk> <20090212104010.26766.20813.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, dwmw2@infradead.org, bernds_cb1@t-online.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] NOMMU: Make it possible for RomFS to use MTD devices directly
Date: Fri, 20 Feb 2009 12:11:21 +0000
Message-ID: <29958.1235131881@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> My x86_64 usualconfig just exploded with
> 
> fs/romfs/storage.c:18:2: error: #error no ROMFS backing store interface configured

To be able to use romfs you have to set one or both of the two backing store
options with this patch.  Commenting out the #error isn't good enough.  This
needs some Kconfig magic, but I'm not sure what.

David
