Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZGJW6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZGJW6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZGJW6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:58:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:42437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZGJW6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:58:00 -0400
Date: Fri, 10 Jul 2009 15:56:15 -0700
From: Greg KH <gregkh@suse.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak in request_firmware()
Message-ID: <20090710225615.GA32643@suse.de>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
 <20090710173623.GA3687@kroah.com>
 <tnxskh4nog0.fsf@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tnxskh4nog0.fsf@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 11:49:35PM +0100, Catalin Marinas wrote:
> Greg KH <greg@kroah.com> wrote:
> > On Tue, Jul 07, 2009 at 04:17:00PM +0100, Catalin Marinas wrote:
> >> I get a couple kmemleak reports like below which I think happen on the
> >> failure path (-ENOENT) of a request_firmware() call:
> >
> > Hm, can you send me the final version of this patch, it seemed to go
> > through a few different versions, with a signed-off-by line?
> 
> It was merged as commit 0f2f2221b4ad8.

Ah, nice, I don't have to worry about it then, thanks.

greg k-h
