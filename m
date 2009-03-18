Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbZCRRFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbZCRRFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZCRRFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:05:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZCRRFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:05:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1237395629.10384.2.camel@think.oraclecorp.com>
References: <1237395629.10384.2.camel@think.oraclecorp.com> <20090318161626.16521.91662.stgit@warthog.procyon.org.uk>
To: Chris Mason <chris.mason@oracle.com>
Cc: dhowells@redhat.com, balajirrao@gmail.com, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Transpose parent_objectid and parent_gen in struct btrfs_fid
Date: Wed, 18 Mar 2009 17:05:05 +0000
Message-ID: <21667.1237395905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> wrote:

> Won't this confuse any handles the clients already have if the server
> reboots with the new handle format?

Perhaps, but it's probably early enough in BTRFS's life to get away with it.

David
