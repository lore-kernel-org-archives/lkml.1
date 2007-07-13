Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbXGMRc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbXGMRc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXGMRcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:32:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbXGMRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:32:19 -0400
Date: Fri, 13 Jul 2007 10:31:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Dave McCracken <dave.mccracken@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] do not limit locked memory when RLIMIT_MEMLOCK is
 RLIM_INFINITY
Message-Id: <20070713103132.38e782e5.akpm@linux-foundation.org>
In-Reply-To: <46979C4E.6000205@oracle.com>
References: <4692D9E0.1000308@oracle.com>
	<20070713004408.b7162501.akpm@linux-foundation.org>
	<46979C4E.6000205@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 08:37:50 -0700 Herbert van den Bergh <herbert.van.den.bergh@oracle.com> wrote:

> Andrew Morton wrote:
> > 
> > OK.  Seems like a nasty bug if one happens to want to do that.  Should we
> > backport this into 2.6.22.x?
> > 
> 
> Yes, please.  Do you need me to do anything for that?
> 

Nope.  I stick a "Cc: <stable@kernel.org>" into the changelog and then
magic happens: the -stable maintainers get a copy of the patch when it goes
to Linus, they get notification when I drop it after Linus merged it and
then they (hopeully) take the patch from Linus's tree.

(But the last step is a bit of a hassle - I suspect they take my emailed
version instead, but it would be super-rare for that to differ from the
version which Linus merged)
