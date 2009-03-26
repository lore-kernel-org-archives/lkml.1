Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbZCZPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbZCZPvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbZCZPuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:50:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51988 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbZCZPuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:50:06 -0400
Date: Thu, 26 Mar 2009 15:48:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu, adobriyan@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/kmemtrace] fs.h: uninline simple_transaction_set()
Message-ID: <20090326154840.GR28946@ZenIV.linux.org.uk>
References: <1237898630.25315.83.camel@penberg-laptop> <tip-44eea45ca9e25d6dd660d4806ef4c11209609e03@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-44eea45ca9e25d6dd660d4806ef4c11209609e03@git.kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 04:51:28PM +0000, Ingo Molnar wrote:
> Commit-ID:  44eea45ca9e25d6dd660d4806ef4c11209609e03
> Gitweb:     http://git.kernel.org/tip/44eea45ca9e25d6dd660d4806ef4c11209609e03
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 25 Mar 2009 16:48:35 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 25 Mar 2009 17:48:14 +0100
> 
> fs.h: uninline simple_transaction_set()
> 
> Move simple_transaction_set() to the other simple-transaction
> file helpers in fs/libfs.c.
> 
> This removes an implicit asm/page.h PAGE_SIZE dependency from
> fs.h (asm/page.h is not an exported header so HEADERS_CHECK fils),
> and also reduces kernel size a bit.

*shrug*

I can live with that.  Which tree do you want that to go through?  I'll
be pushing VFS queue tonight.
