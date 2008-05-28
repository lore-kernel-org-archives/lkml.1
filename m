Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYE1Rja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYE1Rja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYE1RjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:39:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbYE1RjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:39:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com> <2874.1211980355@redhat.com> <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI> <24762.1211983758@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: dhowells@redhat.com, Pekka J Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 18:38:55 +0100
Message-ID: <7613.1211996335@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> wrote:

> Right. SLAB/SLUB align to long long. SLOB needs to do the same.

I fixed it by setting ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN.

David
