Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZITVYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZITVYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZITVYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:24:51 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55969 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZITVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:24:51 -0400
Date: Sun, 20 Sep 2009 17:24:50 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] kbuild: Don't define ALIGN and ENTRY when
 preprocessing linker scripts.
In-Reply-To: <20090920211627.GB27042@merkur.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0909201718490.3101@dr-wily.mit.edu>
References: <1253472193-21106-1-git-send-email-tabbott@ksplice.com> <1253472193-21106-2-git-send-email-tabbott@ksplice.com> <20090920211627.GB27042@merkur.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Sam Ravnborg wrote:

> The reason for __XXX___ for ASSEMBLY and KERNEL is the fact
> that these are used in user space headers.
> 
> I would suggest to use: LINKER_SCRIPT

OK.  I'm happy with calling it LINKER_SCRIPT.

> This will conflict (in a trivial way) with stuff I have
> pending for this merge window.

Is that pending stuff available in a public git repository somewhere?  If 
so, I could send you a version on top of those pending changes.  
(Alternatively, if you're planning to take this patch, I'd be fine with 
your resolving the merge conflict, updating the name, and putting it in 
with your stuff.  Whatever's easier for you).

	-Tim Abbott
