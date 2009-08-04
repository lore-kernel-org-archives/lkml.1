Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbZHDPox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbZHDPox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZHDPow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:44:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43301 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563AbZHDPov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:44:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <18269.1249400306@redhat.com>
References: <18269.1249400306@redhat.com> <20090804151747.GA3698@us.ibm.com> <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145535.17676.87650.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/6] KEYS: Allow keyctl_revoke() on keys that have SETATTR but not WRITE perm
Date: Tue, 04 Aug 2009 16:43:17 +0100
Message-ID: <18380.1249400597@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Without this, you can't revoke keys that don't have an update method.

Actually, that's not true.  Keys aren't automatically given WRITE perm if they
don't have an update method, and so aren't automatically given revoke
permission.

David
