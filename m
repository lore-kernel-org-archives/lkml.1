Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbYBUQsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbYBUQsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763877AbYBUQsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:48:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934152AbYBUQsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:48:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <je4pc2s1r7.fsf@sykes.suse.de>
References: <je4pc2s1r7.fsf@sykes.suse.de> <20080221155402.4414.60360.stgit@warthog.procyon.org.uk>
To: Andreas Schwab <schwab@suse.de>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to do_div()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 21 Feb 2008 16:46:53 +0000
Message-ID: <13346.1203612413@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@suse.de> wrote:

> do_div previously modified temp64 by side effect, now it no longer does
> that.

Good point.

David
