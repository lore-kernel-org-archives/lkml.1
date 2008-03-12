Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYCLRSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYCLRSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYCLRSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:18:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42035 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYCLRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:18:39 -0400
Date: Wed, 12 Mar 2008 17:18:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       matthew@wil.cx, dhowells@redhat.com
Subject: Re: [PATCH] Remove <linux/genhd.h> from user-visible headers.
Message-ID: <20080312171833.GI27894@ZenIV.linux.org.uk>
References: <1205340777.2592.134.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205340777.2592.134.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 05:52:56PM +0100, David Woodhouse wrote:
> It was all wrapped in '#ifdef CONFIG_BLOCK' anyway, so userspace was
> getting nothing useful out of it. And the special #ifndef __KERNEL__
> version of 'struct partition' makes me inclined to promote an attitude
> of violence...
> 
> Stick some comments on some of the #endifs too, while we're at it.

Right...  Actually, if that goes in... the next step is to take fs/partitions
to block and evict more than a half of genhd.h to block/blk.h and relevant
partition handlers.  I have a long-rotten patch for that, will resurrect...
