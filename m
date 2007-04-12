Return-Path: <linux-kernel-owner+w=401wt.eu-S1161581AbXDLKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161581AbXDLKk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXDLKk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:40:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161581AbXDLKk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:40:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1176342114.8061.116.camel@localhost.localdomain> 
References: <1176342114.8061.116.camel@localhost.localdomain> 
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fix bogon in /dev/mem mmap'ing on nommu 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 12 Apr 2007 11:40:12 +0100
Message-ID: <492.1176374412@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> While digging through my MAP_FIXED changes, I found that rather obvious
> bug in /dev/mem mmap implementation for nommu archs. get_unmapped_area()
> is expected to return an address, not a pfn.

Acked-By: David Howells <dhowells@redhat.com>
