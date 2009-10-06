Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZJFHUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZJFHUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZJFHUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:20:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbZJFHUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:20:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4ACAEB6D.2020601@redhat.com>
References: <4ACAEB6D.2020601@redhat.com> <20091005063919.3958.65581.sendpatchset@localhost.localdomain> <22214.1254748402@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch v2] rwsem: fix rwsem_is_locked() bugs
Date: Tue, 06 Oct 2009 08:18:09 +0100
Message-ID: <9987.1254813489@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Amerigo Wang <amwang@redhat.com> wrote:

> Since if we have locks, we don't need memory barriers any more, right?

Indeed - locks are implicit memory barriers.

David
