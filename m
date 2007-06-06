Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbXFFKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbXFFKHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbXFFKHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:07:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXFFKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:07:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070605215035.GH5500@stusta.de>
References: <20070605215035.GH5500@stusta.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/afs/: possible cleanups
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Wed, 06 Jun 2007 11:06:33 +0100
Message-ID: <19071.1181124393@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> This patch contains the following possible cleanups:

Mostly okay, though:

>   - mntpt.c: afs_mntpt_expiry_timeout
>   - server.c: afs_server_timeout
>   - vlocation.c: afs_vlocation_timeout
>   - vlocation.c: afs_vlocation_update_timeout

all conflict with my config patch.  However, since that's not finished yet, I
don't mind reverting your changes later.

Acked-By: David Howells <dhowells@redhat.com>
