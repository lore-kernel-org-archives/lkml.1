Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYD2PjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYD2PjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbYD2Piq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:38:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933816AbYD2Pip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:38:45 -0400
Date: Tue, 29 Apr 2008 08:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] toshiba: Use ioremap_cached
Message-Id: <20080429083704.41855699.akpm@linux-foundation.org>
In-Reply-To: <20080429152312.GB19410@elte.hu>
References: <20080429142023.093bfba6@core>
	<20080429141559.GB26461@elte.hu>
	<20080429081408.c9dc6b4f.akpm@linux-foundation.org>
	<20080429152312.GB19410@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 17:23:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Acked-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > i suspect this shouldnt go via x86.git but i've queued it up to 
> > > track it.
> > 
> > Please don't "queue things up to track them".  Just queue them up to 
> > merge them, or don't queue them at all.
> > 
> > Because if you queue it up then I will not.  If you later for some 
> > reason unqueue it then volia, it is lost.  We should aim to avoid 
> > having multiple copies of a patch sitting around the place.
> 
> but ... i dont just unqueue 'for some reason and then volia'. If we did 
> that we'd be losing patches left and right. Every patch we unqueue 
> happens in a very predictable protocol that should avoid patches getting 
> lost.
> 
> ( basically we only remove any patch when they are broken but even then
>   there's a clear notification. Even a NAK or other fatal review 
>   feedback does not actually remove a patch in the typical case when the 
>   patch otherwise has practical use, and update is hoped for and the 
>   patch does not break things - it just freezes the patch at the "must 
>   not go upstream yet" end of the queue. )
> 
> if we lose any patches then let us know so we can improve the protocol.

OK, in that case please don't say "i've queued it up to track it"!

Stick to the unambiguous, non-akpm-scary "applied" :)
