Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601Ab0ADMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0ADMeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338Ab0ADMef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:34:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:58127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0ADMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:34:34 -0500
Date: Mon, 4 Jan 2010 04:36:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       kent.liu@intel.com, chaohong.guo@intel.com, youquan.song@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]tickless: Fix tick nohz timer irq0 fail to increaase
Message-ID: <20100104043650.6acfb056@infradead.org>
In-Reply-To: <20100104104905.GA30574@youquan-linux.bj.intel.com>
References: <20091214130233.GA3898@youquan-linux.bj.intel.com>
	<20100104104905.GA30574@youquan-linux.bj.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 05:49:05 -0500
"Youquan,Song" <youquan.song@linux.intel.com> wrote:

> Tickless is disabled by nohz=off, which is used in OSVs.

it is? I doubt anyone wants to normally disable tickless, the power
cost is just too high....

> But in
> current kernel, if tickless is disabled, the timer irq0 will not
> increase.

why is this a problem? 

> Because the timer event handler should be
> tick_handle_periodic, but actually event handler keep as
> tick_handle_oneshot_broadcast which is used in tickless. The root
> cause is that it is default to enable high resolution timer which
> will force to oneshot broadcast mode.

using local apic in one shot mode is not a problem, I'd in fact call it
a feature...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
