Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYE2UKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYE2UKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYE2UK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:10:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbYE2UK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:10:28 -0400
Date: Thu, 29 May 2008 13:08:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, bunk@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Werror: Fix casting wrong size integer to pointer
Message-Id: <20080529130837.314b8410.akpm@linux-foundation.org>
In-Reply-To: <17009.1212089124@redhat.com>
References: <20080529121942.b6d768e7.akpm@linux-foundation.org>
	<20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
	<17009.1212089124@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 20:25:24 +0100
David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > yup, what Linus said.  This one's been irritating me for years, and I
> > got close to tempting Markus into fixing it before he departed the
> > scene.  But it remains, as a little "might be busted on 64 bit" reminder.
> 
> Is it worth making the driver only available for non-64-bit arches?
> 

I don't know whether anyone is using it on 64-bit machines.  If they
are, disabling it would probably wake someone up.

Perhaps it all happens to work OK on 64-bit.  I just don't know, sorry.
A bit of lkml/bugzilla/google data mining would reveal the status, I
guess.
