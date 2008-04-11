Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYDKKQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYDKKQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758329AbYDKKQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:16:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758260AbYDKKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:16:45 -0400
Date: Fri, 11 Apr 2008 03:16:42 -0700 (PDT)
Message-Id: <20080411.031642.193716019.davem@davemloft.net>
To: dhowells@redhat.com
Cc: harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] kernel: Move arches to use common unaligned access
From: David Miller <davem@davemloft.net>
In-Reply-To: <15208.1207908688@redhat.com>
References: <1207885132.22001.85.camel@brick>
	<15208.1207908688@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 11 Apr 2008 11:11:28 +0100

> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > - * impractical.  So, now we fall back to using memcpy.
> > + * impractical.  So, now we fall back to using memmov.
> 
> That's memmove, not memmov.  Any why memmove, not memcpy?  Is __tmp likely to
> overlap with *ptr?

No, I think it has something to do with what cases GCC is allowed to
optimize the call inline and what cases it cannot wrt.  alignment of
datums.
