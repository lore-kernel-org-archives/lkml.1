Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYFBL40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYFBL40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYFBL4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:56:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYFBL4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:56:18 -0400
Subject: Re: [BUG] JFFS2 power loss recovery issues in 2.6.25, 2.6.26-rc
From: David Woodhouse <dwmw2@infradead.org>
To: Alexey Korolev <akorolev@infradead.org>
Cc: Jared Hulbert <jaredeh@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806021239440.5100@pentafluge.infradead.org>
References: <alpine.LFD.1.10.0805291205480.22130@pentafluge.infradead.org>
	 <6934efce0805301224t5e5d7a01n3b652c4df5324d58@mail.gmail.com>
	 <alpine.LFD.1.10.0806021239440.5100@pentafluge.infradead.org>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 12:56:14 +0100
Message-Id: <1212407774.16924.120.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 12:41 +0100, Alexey Korolev wrote:
> Hi,
> > > We made some investigations for this issue and found commit number which
> > > breaks JFFS2 power loss recoverability.
> > > It is:  [JFFS2] Improve getdents vs. f_pos handling on NOR flash.
> > >        http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=15953580e79b58caefb107e77f218e009b9992e6
> > >
> > > Currently we don't know why it breaks JFFS2 and how it could be fixed
> > > except roll back.
> > 
> > Does everything work when you unmerge this one commit?
> > 
> Correct, commit roll back fixes the problem. 

But leaves another one. I was away last week, and I'm home now -- I'll
try to reproduce and understand what's going on.

-- 
dwmw2

