Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbXH1Tbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbXH1Tbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbXH1TTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:19:15 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58131 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762735AbXH1TTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:19:13 -0400
Date: Tue, 28 Aug 2007 15:19:07 -0400
To: Valdis.Kletnieks@vt.edu
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070828191907.GE3764@fieldses.org>
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org> <7788.1188328346@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7788.1188328346@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 03:12:26PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 27 Aug 2007 17:43:33 EDT, "J. Bruce Fields" said:
> > I also wonder whether these shouldn't all be dprintk's instead of
> > printk's.  One misbehaving client could create a lot of noise in the
> > logs.
> 
> I shouldn't have to rebuild my kernel with debugging enabled just to see
> who is throwing trash at my machine.

Fair enough.

The dprintk's throughout the nfs and sunrpc server and client code can
be selectively enabled at runtime using a set of sysctls in
sys/sunrpc/*_debug; see

	include/linux/lockd/debug.h
	include/linux/nfsd/debug.h
	include/linux/sunrpc/debug.h

--b.
