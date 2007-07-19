Return-Path: <linux-kernel-owner+w=401wt.eu-S934536AbXGSMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536AbXGSMzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbXGSMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:55:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133AbXGSMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:55:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070719090620.GA14799@kernel.sg>
References: <20070719090620.GA14799@kernel.sg>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/afs/flock.c: posix_test_lock() returns void
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 19 Jul 2007 13:55:26 +0100
Message-ID: <26568.1184849726@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Teo <eugeneteo@kernel.sg> wrote:

> posix_test_lock() returns void, so there is no need to test the return value.
> Checking fl->fl_type for F_UNLCK instead.

Yep, thanks.  Andrew Morton already has a patch for this.

David
