Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbXELTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbXELTI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbXELTIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:08:20 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:50574 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbXELTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:08:19 -0400
Date: Sat, 12 May 2007 21:08:13 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Xen-devel <xen-devel@lists.xensource.com>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 19/28]xen: Add early printk support via hvc console
Message-ID: <20070512190813.GA17757@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
	Xen-devel <xen-devel@lists.xensource.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20070511000643.025196000@goop.org> <20070511001204.948444000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070511001204.948444000@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:07:02PM -0700, Jeremy Fitzhardinge wrote:
> +#ifdef CONFIG_XEN

xenboot_console is only available with CONFIG_HVC_XEN.

> +	} else if (!strncmp(buf, "xen", 3)) {
> + 		early_console = &xenboot_console;
> +#endif
