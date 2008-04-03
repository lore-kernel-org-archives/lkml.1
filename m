Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbYDCSBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbYDCSBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYDCSBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:01:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbYDCSBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:01:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b6c5339f0804031015u2b2dcc6cyd225cd41e45ddd3e@mail.gmail.com>
References: <b6c5339f0804031015u2b2dcc6cyd225cd41e45ddd3e@mail.gmail.com> <20080402174813.10046.80641.stgit@warthog.procyon.org.uk>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: The AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 03 Apr 2008 19:01:08 +0100
Message-ID: <12116.1207245668@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland <me@bobcopeland.com> wrote:

> >  +static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
> >  +       .name           = "CB.",
> >  +       .deliver        = afs_deliver_cb_tell_me_about_yourself,
> 
> Just curious, is .name meant to be that way?

Ummm... No.

David
