Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbYD2PPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbYD2PPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760240AbYD2PPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:15:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbYD2PPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:15:08 -0400
Date: Tue, 29 Apr 2008 08:14:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] toshiba: Use ioremap_cached
Message-Id: <20080429081408.c9dc6b4f.akpm@linux-foundation.org>
In-Reply-To: <20080429141559.GB26461@elte.hu>
References: <20080429142023.093bfba6@core>
	<20080429141559.GB26461@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 16:15:59 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > The switch of ioremap to default to uncached doesn't break this driver
> > but it does needlessly slow it down as BIOS space is cachable and this
> > driver is quite happy scanning cached ROM space.
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> i suspect this shouldnt go via x86.git but i've queued it up to track 
> it.

Please don't "queue things up to track them".  Just queue them up to merge
them, or don't queue them at all.

Because if you queue it up then I will not.  If you later for some reason
unqueue it then volia, it is lost.  We should aim to avoid having multiple
copies of a patch sitting around the place.

I shall not merge this patch - it is yours.

> Is there an active maintainer for this file?

drivers/char/*?  Very rarely maintained.  git-whatchanged tells the story
on this one: no.

