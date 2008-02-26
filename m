Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYBZCCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYBZCCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYBZCCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:02:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbYBZCCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:02:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0802260228430.2723@scrub.home>
References: <Pine.LNX.4.64.0802260228430.2723@scrub.home> <20080221155402.4414.60360.stgit@warthog.procyon.org.uk>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to do_div()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 26 Feb 2008 02:01:59 +0000
Message-ID: <24903.1203991319@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> wrote:

> I would actually prefer to introduce an explicit API for signed 64 
> divides to get rid of the temps completely

Yeah, that's a better plan.

David
