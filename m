Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbXFEF0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbXFEF0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 01:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXFEF0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 01:26:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37615 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbXFEF0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 01:26:10 -0400
Date: Tue, 5 Jun 2007 07:27:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: default charset for linux-kernel code?
Message-ID: <20070605052711.GA21745@uranus.ravnborg.org>
References: <20070604213645.GA18588@uranus.ravnborg.org> <20070604231115.GG5500@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604231115.GG5500@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 01:11:15AM +0200, Adrian Bunk wrote:
> On Mon, Jun 04, 2007 at 11:36:45PM +0200, Sam Ravnborg wrote:
> > In private mail I have discussed with a person the default charset
> > to use for source code and in particular Kconfig files in the kernel.
> > I recall to have seen some mails about UTF-8 but I would like to have
> > confirmed what is the 'nofficial?' recommended charset for kernel code?
> 
> Everything that gets compiled into the kernel image (including printk()'s
> but excluding comments) 7bit ASCII, the rest UTF-8.
> 
> For Kconfig files UTF-8 should be the right choice (assuming all
> *config tools support it).

Thanks - this also matches my understanding.

	Sam
