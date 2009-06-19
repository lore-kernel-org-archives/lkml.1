Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZFSBsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZFSBsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZFSBr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:47:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:38546 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZFSBr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:47:56 -0400
Message-ID: <4A3AEE42.4010300@kernel.org>
Date: Fri, 19 Jun 2009 10:47:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
References: <4A39F5B4.1070305@kernel.org> <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain> <4A3AC0BA.4000407@kernel.org>
In-Reply-To: <4A3AC0BA.4000407@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 19 Jun 2009 01:47:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Tejun Heo wrote:
> Oops, my apologies.  I had them as floating series and apparently used
> different base commit when applying them.  I did grep run and full yes
> build on the original quilt tree but didn't after quiltimport.  Sorry.

I digged through git changelogs to find out where it went wrong.  I
did use the same base commit when quiltimporting but when I updated
the patches on top of mainline two days ago, I forgot to quilt add the
file and the mce change got committed to the base tree instead of
quilt patch.  After pulling the latest master into the quilt branch
yesterday, I updated the series for newcomers and everything worked
fine (as the base tree change got merged by git).  quiltimporting of
course lost the base tree change and thinking the output gotta be
identical I didn't test the final git tree.

Anyways, I'm dropping the for-linus branch from percpu tree, fixing it
up, adding patchsets scheduled for .32 release and will try to get it
merged into #linux-next.

Thanks.

-- 
tejun
