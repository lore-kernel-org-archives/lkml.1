Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZFQSFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZFQSFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZFQSFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:05:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZFQSFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:05:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090617075137.GA13073@webber.adilger.int>
References: <20090617075137.GA13073@webber.adilger.int> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <20090616203937.4526.53619.stgit@warthog.procyon.org.uk>
To: Andreas Dilger <adilger@sun.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>
Subject: Re: [PATCH 10/17] AFS: Implement the PWhereIs pioctl
Date: Wed, 17 Jun 2009 19:05:03 +0100
Message-ID: <28281.1245261903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@sun.com> wrote:

> What happens with IPv6?

Currently AFS doesn't support IPv6.  There need to be some protocol changes
for that to happen, for instance the volume location server needs to return
IPv6 records for its fileservers if that's the right way to access them.

David
