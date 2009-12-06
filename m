Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbZLFRle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbZLFRle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934007AbZLFRlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:41:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39604 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbZLFRlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:41:32 -0500
Date: Sun, 6 Dec 2009 17:41:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/18] arch_mmap_check() on mn10300
Message-ID: <20091206174137.GD14381@ZenIV.linux.org.uk>
References: <E1NGzzv-0008Rh-1X@ZenIV.linux.org.uk> <21624.1260121092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21624.1260121092@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 05:38:12PM +0000, David Howells wrote:
> Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > +#define arch_mmap_chech(addr, len, flags) \
> > +	(((flags) & MAP_FIXED && (addr) < MIN_MAP_ADDR) ? -EINVAL : 0)
> 
> I believe that should be arch_mmap_check().

D'oh.  Thanks for spotting (and that, BTW, is a nice demonstration
of the reasons why "arch hooks with default" thing is bad).  Fixed in
my tree, will go in the next repost.
