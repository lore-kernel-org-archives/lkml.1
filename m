Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311Ab0AKMMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0AKMMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:12:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116Ab0AKMMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:12:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0AKMMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:12:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a1001081655s4ee3d4a7q3ef6a10d211ce6d1@mail.gmail.com>
References: <8bd0f97a1001081655s4ee3d4a7q3ef6a10d211ce6d1@mail.gmail.com> <20100108220516.23489.11319.stgit@warthog.procyon.org.uk> <20100108220533.23489.99121.stgit@warthog.procyon.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, lethal@linux-sh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] NOMMU: Don't need get_unmapped_area() for NOMMU
Date: Mon, 11 Jan 2010 12:11:51 +0000
Message-ID: <20843.1263211911@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> static inline instead of extern when !MMU ?

Yep.  The fix accidentally wound up in the next patch.  I'll move it.

David
