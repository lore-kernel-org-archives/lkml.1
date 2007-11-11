Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbXKKPIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbXKKPIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXKKPIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:08:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbXKKPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:08:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071110200935.60d375de@the-village.bc.nu>
References: <20071110200935.60d375de@the-village.bc.nu> <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk> <24343.1194697130@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the kernel [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 15:07:51 +0000
Message-ID: <1745.1194793671@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> memory mapped registers should be read with readw and friends and that
> should contain the volatile not the public code.

Actually, I can think of a good reason for *not* doing that.  What I have at
the moment encodes the size of the register to be accessed in the type.  What
you're suggesting does not.

David
