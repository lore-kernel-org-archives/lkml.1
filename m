Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYLJArS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYLJArS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYLJArE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:47:04 -0500
Received: from mail.suse.de ([195.135.220.2]:40179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYLJArC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:47:02 -0500
Date: Tue, 9 Dec 2008 16:44:41 -0800
From: Greg KH <gregkh@suse.de>
To: Zachary Amsden <zach@vmware.com>
Cc: norman@thebacks.co.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, mingo <mingo@elte.hu>,
       Alok Kataria <alokkataria1@gmail.com>, <bruno.premont@restena.lu>,
       xl@xlsigned.net, dsd@gentoo.org
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
Message-ID: <20081210004441.GB18520@suse.de>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 04:50:21PM -0800, Zachary Amsden wrote:
> Patches backported into 2.6.27.4 caused a regression with VMI kernels
> running on VMware which ends in a page fault during boot.  I have a fix
> which still allows DMI checks to be done early.

Is this regression also present on 2.6.28-rc kernels as well?

thanks,

greg k-h
