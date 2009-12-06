Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbZLFRiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbZLFRiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933999AbZLFRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:38:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933989AbZLFRiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:38:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1NGzzv-0008Rh-1X@ZenIV.linux.org.uk>
References: <E1NGzzv-0008Rh-1X@ZenIV.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/18] arch_mmap_check() on mn10300
Date: Sun, 06 Dec 2009 17:38:12 +0000
Message-ID: <21624.1260121092@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:

> +#define arch_mmap_chech(addr, len, flags) \
> +	(((flags) & MAP_FIXED && (addr) < MIN_MAP_ADDR) ? -EINVAL : 0)

I believe that should be arch_mmap_check().

David
