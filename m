Return-Path: <linux-kernel-owner+w=401wt.eu-S1766816AbXEBUIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766816AbXEBUIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766909AbXEBUIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:08:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766816AbXEBUII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:08:08 -0400
Date: Wed, 2 May 2007 13:07:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
Message-Id: <20070502130746.265bba0f.akpm@linux-foundation.org>
In-Reply-To: <4638CC03.7030903@imap.cc>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46338AEB.2070109@imap.cc>
	<20070428141024.887342bd.akpm@linux-foundation.org>
	<4636248E.7030309@imap.cc>
	<20070430112130.b64321d3.akpm@linux-foundation.org>
	<46364346.6030407@imap.cc>
	<20070430124638.10611058.akpm@linux-foundation.org>
	<46383742.9050503@imap.cc>
	<20070502001000.8460fb31.akpm@linux-foundation.org>
	<20070502075238.GA9083@suse.de>
	<4638CC03.7030903@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 19:36:03 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 02.05.2007 09:52 schrieb Greg KH:
> > Tilman, here's a patch, can you try this on top of your tree that dies?
> 
> 2.6.21-git3 plus that patch comes up fine.
> 
> (Except for a UDP problem I seem to remember I already saw reported
> on lkml and which I'll ignore for now in order not to blur the
> picture.)

Thanks.

> Started to git-bisect mainline now, but that will take some time.
> It's more than 800 patches to check and I don't get more than 2-3
> iterations per day out of that machine.

I don't think there's much point in you doing that.  We know what the bug is.

Switching to 8k stacks will probably fix things up too.
