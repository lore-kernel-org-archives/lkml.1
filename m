Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYDCSFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYDCSFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYDCSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:05:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbYDCSFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:05:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080403180300.13644.68956.stgit@warthog.procyon.org.uk>
References: <20080403180300.13644.68956.stgit@warthog.procyon.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: The AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 03 Apr 2008 19:04:57 +0100
Message-ID: <13766.1207245897@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
> +	.name		= "CB.",
> +	.deliver	= afs_deliver_cb_tell_me_about_yourself,

I really must get Catalin to make "stg mail" refuse to send mails if there are
outstanding changes.

David
