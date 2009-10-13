Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbZJMCgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbZJMCgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbZJMCgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:36:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693AbZJMCgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:36:22 -0400
Date: Mon, 12 Oct 2009 19:12:38 -0700
From: Greg KH <gregkh@suse.de>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.2 broke UML 64-bit build (2.6.31 was fine)
Message-ID: <20091013021238.GA13241@suse.de>
References: <4AD34542.7050500@nagafix.co.uk> <20091012160548.GA3961@hack> <4AD36022.4090300@nagafix.co.uk> <2375c9f90910121854v72422318u6b8f67f4437e4066@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f90910121854v72422318u6b8f67f4437e4066@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 09:54:52AM +0800, Am??rico Wang wrote:
> On Tue, Oct 13, 2009 at 12:58 AM, Antoine Martin <antoine@nagafix.co.uk> wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA512
> >
> >> Hmm, this is a known problem:
> >> https://lists.linux-foundation.org/pipermail/bugme-new/2009-May/021900.html
> > How odd that I have been compiling successfully all that time!
> > Maybe the fact that it broke "more" recently will help you...
> 
> Please try this patch:
> 
> http://patchwork.kernel.org/patch/48759/
> 
> It should fix your problem.
> 
> What I can do here is to suggest -stable team to include this patch in the
> next update for .31. Greg?

Send the git commit id of the patch that fixes the problem that is
already in Linus's tree to stable@kernel.org and cc: me.

thanks,

greg k-h
