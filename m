Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZIHBuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZIHBuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 21:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZIHBuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 21:50:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZIHBun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 21:50:43 -0400
Date: Mon, 7 Sep 2009 21:50:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/8] Do not call 'ima_path_check()' for each path
	component
Message-ID: <20090908015043.GA26051@infradead.org>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 02:02:16PM -0700, Linus Torvalds wrote:
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 28 Aug 2009 10:05:33 -0700
> 
> Not only is that a supremely timing-critical path, but it's hopefully some 
> day going to be lockless for the common case, and ima can't do that.
> 
> Plus the integrity code doesn't even care about non-regular files,
> so it was always a total waste of time and effort.

Haha, nice one.

