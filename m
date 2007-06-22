Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXFVNgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXFVNgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbXFVNgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:36:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbXFVNgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:36:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46695F6D.5050600@t-online.de>
References: <46695F6D.5050600@t-online.de>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 22 Jun 2007 14:35:57 +0100
Message-ID: <17366.1182519357@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> Excess pages will be freed if MAP_SPLIT_PAGES is passed to mmap.

How about MAP_TRIM_EXCESS instead of MAP_SPLIT_PAGES?  I think it fits the
function better.

David
