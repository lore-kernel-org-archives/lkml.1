Return-Path: <linux-kernel-owner+w=401wt.eu-S965327AbXIGLCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327AbXIGLCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 07:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965160AbXIGLCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 07:02:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965155AbXIGLCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 07:02:16 -0400
Date: Fri, 7 Sep 2007 04:01:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1 build issue: ia64 link error
Message-Id: <20070907040104.fad5fc70.akpm@linux-foundation.org>
In-Reply-To: <617E1C2C70743745A92448908E030B2A025B103D@scsmsx411.amr.corp.intel.com>
References: <20070906183546.GA1449@Krystal>
	<617E1C2C70743745A92448908E030B2A025B103D@scsmsx411.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 7 Sep 2007 00:34:59 -0700 "Luck, Tony" <tony.luck@intel.com> wrote:
> > local symbol 0: discarded in section `.exit.text' from arch/ia64/kernel/built-in.o
> 
> This usually means that there is a static __exit function (or __devexit etc.)
> somewhere in the object being linked.  The error message is pretty unhelpful
> in figuring out *where* in the module.  Look at the 'mm' patches that touch
> arch/ia64/kernel to see if one of them tinkers with __exit* attributes.
> 

Confused.  There are >2500 static __exit functions in the tree, including
ones like

arch/ia64/kernel/esi.c:static void __exit esi_exit (void)

Could we have some more details on what you think has gone wrong here?
