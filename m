Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXHVA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXHVA2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXHVA21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:28:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:52202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbXHVA20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:28:26 -0400
Date: Wed, 22 Aug 2007 03:22:16 +0200
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Message-ID: <20070822012216.GN32640@bingen.suse.de>
References: <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de> <1187313920.28497.1.camel@caritas-dev.intel.com> <46C5C8C4.4060407@zytor.com> <1187580031.27947.67.camel@caritas-dev.intel.com> <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de> <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de> <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> current LinuxBIOS's path: the elfboot in LinuxBIOS will prepare the
> e820 table, and jump to startup_32 in kernel. is that not good and
> simple? 

The problem is that the zero page cannot be changed at all in this
setup. Or rather it can be only changed by breaking LinuxBios.

-Andi

