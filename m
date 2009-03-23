Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZCWK32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZCWK32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZCWK3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:29:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57105 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZCWK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:29:19 -0400
Date: Mon, 23 Mar 2009 10:29:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 13/13] inotify: reimplement inotify using fsnotify
Message-ID: <20090323102914.GP28946@ZenIV.linux.org.uk>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com> <20090319180604.17449.60430.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319180604.17449.60430.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:06:04PM -0400, Eric Paris wrote:

> +		holder = alloc_event_holder();
> +		if (!holder) {
> +			spin_unlock(&event->lock);

Um.  Your alloc_event_holder() is using GFP_KERNEL...
