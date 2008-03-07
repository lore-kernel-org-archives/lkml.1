Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbYCGJs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbYCGJs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYCGJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:48:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbYCGJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:48:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <47CFD7F8.9010903@cse.iitk.ac.in>
References: <47CFD7F8.9010903@cse.iitk.ac.in>
To: Arun Raghavan <arunsr@cse.iitk.ac.in>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow clients to set key perms in key_create_or_update()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 07 Mar 2008 09:48:38 +0000
Message-ID: <25831.1204883318@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Raghavan <arunsr@cse.iitk.ac.in> wrote:

> The key_create_or_update() function provided by the keyring code has a default
> set of permissions that are always applied to the key when created. This might
> not be desirable to all clients.
> 
> Here's a patch that adds a "perm" parameter to the function to address this,
> which can be set to KEY_PERM_UNDEF to revert to the current behaviour.

I'll get to this shortly.  I'm just creating another keyrings patch, so I'll
look at yours afterwards.

David
