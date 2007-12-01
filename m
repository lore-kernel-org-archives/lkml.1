Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbXLADUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbXLADUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbXLADTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:19:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50421 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537AbXLADTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:19:51 -0500
Date: Fri, 30 Nov 2007 19:18:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, mlord@pobox.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Message-ID: <20071130191816.3e744205@laptopd505.fenrus.org>
In-Reply-To: <4750D180.6080001@rtr.ca>
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>
	<20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
	<20071130190227.1976e682@laptopd505.fenrus.org>
	<4750D180.6080001@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 22:14:08 -0500
Mark Lord <lkml@rtr.ca> wrote:

> > in -mm there is.. the QoS stuff allows you to set maximum tolerable
> ..
> 
> That's encouraging, I think, but not for 2.6.24.
> 
> > latency. If your app cant take any latency, you should set those...
> > and the side effect is that the kernel will not do long-latency
> > C-states or P-state transitions..
> ..
> 
> I don't mind the cpufreq changing (actually, I want it to drop in
> cpugfreq to save power and keep the fan off), but the C-states just
> kill this app.
> 
> The app is VMware.  I force the max_state=1 when launching,

ah but then its' even easier... and can be done in 2.6.24 already.
VMWare after all has a kernel module, and the latency stuff is in
2.6.23 and 2.6.24 available inside the kernel already.

> 
> I'm not sure about C?? -- it could be C8 or even be C2 or whatever.
> I suppose I should find out, but that really takes a lot of fuss
> (hours) to measure, and isn't strictly repeatable.

(also hope you don't have one of those AMD machines where the bios
turns C1 into C2/C3/etc behind the OSes back ;-)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
