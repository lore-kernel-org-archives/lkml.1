Return-Path: <linux-kernel-owner+w=401wt.eu-S932682AbXHAOur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbXHAOur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbXHAOug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:50:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbXHAOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:50:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1185976630.3468.73.camel@localhost.localdomain>
References: <1185976630.3468.73.camel@localhost.localdomain> <20070801091353.10608.32356.stgit@warthog.cambridge.redhat.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@osdl.org, akpm@osdl.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Make BSG declarations dependent on CONFIG_BLOCK
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 01 Aug 2007 15:44:56 +0100
Message-ID: <28317.1185979496@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:

> Are you sure you're testing with git head?  CONFIG_BLK_DEV_BSG cannot be
> set unless CONFIG_BLOCK is (which was a bug in previous releases now
> fixed in git head ... unless the fix has gone wrong?).

Neither CONFIG_BLK_DEV_BSG nor CONFIG_BLOCK are set.  The problem is that the
stub BSG functions refer to undefined structures when CONFIG_BLOCK=n.

David
