Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYFCJFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYFCJFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYFCJFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:05:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50691 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYFCJF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:05:29 -0400
Date: Tue, 3 Jun 2008 10:05:26 +0100 (BST)
From: Alexey Korolev <akorolev@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Jared Hulbert <jaredeh@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] JFFS2 power loss recovery issues in 2.6.25, 2.6.26-rc
In-Reply-To: <1212407774.16924.120.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.1.10.0806030951001.15548@pentafluge.infradead.org>
References: <alpine.LFD.1.10.0805291205480.22130@pentafluge.infradead.org>  <6934efce0805301224t5e5d7a01n3b652c4df5324d58@mail.gmail.com>  <alpine.LFD.1.10.0806021239440.5100@pentafluge.infradead.org> <1212407774.16924.120.camel@pmac.infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
> On Mon, 2008-06-02 at 12:41 +0100, Alexey Korolev wrote:
> > Hi,
> > > > We made some investigations for this issue and found commit number which
> > > > breaks JFFS2 power loss recoverability.
> > > > It is:  [JFFS2] Improve getdents vs. f_pos handling on NOR flash.
> > > >        http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=15953580e79b58caefb107e77f218e009b9992e6
> > > >
> > > > Currently we don't know why it breaks JFFS2 and how it could be fixed
> > > > except roll back.
> > > 
> > > Does everything work when you unmerge this one commit?
> > > 
> > Correct, commit roll back fixes the problem. 
> 
> But leaves another one. I was away last week, and I'm home now -- I'll
> try to reproduce and understand what's going on.
> 
> 
We made more investigations of this problem. Joakim has assisted us to understan the patch. This patch can't break PLR feature on NAND. The only way it affects on tests is timing. So commit roll back will not fix the problem, but hides. 

Now we are collecting more information about the problem. We will let you know as
soon as we find something interesting about it. 

Thanks,
Alexey

