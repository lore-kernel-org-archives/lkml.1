Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZASMaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZASMaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZASMaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:30:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38716 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZASMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:30:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090119211031.934b4c19.sfr@canb.auug.org.au>
References: <20090119211031.934b4c19.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] creds: suppress warning in get_cred
Date: Mon, 19 Jan 2009 12:29:31 +0000
Message-ID: <11956.1232368171@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> +	return get_new_cred((struct cred *)(uintptr_t)cred);

That should probably be 'unsigned long' within the kernel.  This is also a
compiler bug, but I think we can live with this fix.

David
