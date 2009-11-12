Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbZKLM6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbZKLM6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZKLM6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:58:45 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59269 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZKLM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:58:44 -0500
Date: Thu, 12 Nov 2009 21:58:48 +0900 (JST)
Message-Id: <20091112.215848.433001257743355256.mitake@dcl.info.waseda.ac.jp>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Removing wrong judgement of checkpatch.pl for
 return as function
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091112124945.GG9335@shadowen.org>
References: <20091106222828.GC5191@penfold>
	<20091107.101429.21010532507617430.mitake@dcl.info.waseda.ac.jp>
	<20091112124945.GG9335@shadowen.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH][RFC] Removing wrong judgement of checkpatch.pl for return as function
Date: Thu, 12 Nov 2009 12:49:45 +0000

> On Sat, Nov 07, 2009 at 10:14:29AM +0900, Hitoshi Mitake wrote:
> 
> > Yes, I post the patch triggered the error I mentioned to lkml recently.
> > I'm attaching the patch the tail of this mail.
> 
> > +		return (pthread_t)0;
> 
> Ahh, now I see how this could occur.  My test case has a variable where
> this has a 0.  I think I've fixed this.  Could you test with the version
> at the URL below (it may take a little time to replicate):
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

I've tested your new checkpatch.pl with the patch I posted as a sample case.
And I didn't get an error I reported! It seems that checkpatch.pl works well.

Thanks,
	Hitoshi
