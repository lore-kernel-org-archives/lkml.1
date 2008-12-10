Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYLJGgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYLJGgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 01:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYLJGgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 01:36:13 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:36409 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbYLJGgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 01:36:12 -0500
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
From: Zachary Amsden <zach@vmware.com>
To: Greg KH <gregkh@suse.de>
Cc: "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, mingo <mingo@elte.hu>,
       Alok Kataria <alokkataria1@gmail.com>,
       "bruno.premont@restena.lu" <bruno.premont@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
In-Reply-To: <20081210004441.GB18520@suse.de>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
	 <20081210004441.GB18520@suse.de>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 23:30:05 -0800
Message-Id: <1228894205.8766.20.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 16:44 -0800, Greg KH wrote:
> On Tue, Dec 09, 2008 at 04:50:21PM -0800, Zachary Amsden wrote:
> > Patches backported into 2.6.27.4 caused a regression with VMI kernels
> > running on VMware which ends in a page fault during boot.  I have a fix
> > which still allows DMI checks to be done early.
> 
> Is this regression also present on 2.6.28-rc kernels as well?

Yes, I reproduced and fixed this on a git tree synced to mainline today.

Thanks,

Zach

