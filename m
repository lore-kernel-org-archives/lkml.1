Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbYHVUDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbYHVUDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHVUDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:03:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYHVUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:03:33 -0400
Date: Fri, 22 Aug 2008 13:02:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: ehabkost@redhat.com, benh@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 3] add phys_addr_t for holding physical addresses
Message-Id: <20080822130235.af69ccb5.akpm@linux-foundation.org>
In-Reply-To: <73196c9129c7298f2428.1219176170@localhost>
References: <patchbomb.1219176169@localhost>
	<73196c9129c7298f2428.1219176170@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 13:02:50 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add a kernel-wide "phys_addr_t" which is guaranteed to be able to hold
> any physical address.  By default it equals the word size of the
> architecture, but a 32-bit architecture can set ARCH_PHYS_ADDR_T_64BIT
> if it needs a 64-bit phys_addr_t.
> 

You say this is a bugfix but you don't describe the bug.  This makes it
rather hard to make the 2.6.2[5678] decisions.

Ditto on [patch 2/3].
