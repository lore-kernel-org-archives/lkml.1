Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZIOPcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZIOPcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZIOPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:32:09 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53927 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbZIOPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:32:08 -0400
Date: Tue, 15 Sep 2009 17:32:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [1/5] kbuild: Fix ld-option Makefile macro to really
	work
Message-ID: <20090915153211.GB9905@merkur.ravnborg.org>
References: <200909141018.915641783@firstfloor.org> <20090914201806.EE6A0B1757@basil.firstfloor.org> <20090914214711.GB7990@merkur.ravnborg.org> <20090915130146.GA12351@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915130146.GA12351@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 03:01:47PM +0200, Andi Kleen wrote:
> > So now we pass the option direct to the linker rather than via gcc -wl.
> > I assume this breaks the other 8 uses of ld-option in the kernel?
> > 
> > Or does ld understand the -wl,... syntax?
> 
> It does not. But -X is passed directly to the linker, not via gcc,
> so it needs to probe ld directly
> 
> The right fix is probably an new macro that works with ld (and
> ideally rename this one which is confusingly named) I'll
> send an updated patch.
Thanks.
Please do remember to update the documentation
in Documentation/kbuild/makefiles.txt.

	Sam
