Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYKPDsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYKPDsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 22:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYKPDs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 22:48:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:35805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYKPDs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 22:48:26 -0500
Date: Sat, 15 Nov 2008 19:49:14 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081115194914.6791b96c@infradead.org>
In-Reply-To: <1226793823-32360-3-git-send-email-bwalle@suse.de>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
	<1226793823-32360-3-git-send-email-bwalle@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 01:03:43 +0100
Bernhard Walle <bwalle@suse.de> wrote:

> When CONFIG_STRICT_DEVMEM is set, live debugging is not possible with
> the crash utility (see http://people.redhat.com/~anderson). For
> distributors who ship a generic kernel it's difficult: Disabling
> CONFIG_STRICT_DEVMEM is possible, but in general the protection
> provided by CONFIG_STRICT_DEVMEM is useful. However, live debugging
> should be still neceessary.
> 
> This patch now adds a dev.mem.restricted sysctl that defaults to 0
> (off). When set to 1 (on), /dev/mem access is unrestricted and crash
> can be used.
> 


sounds like a really bad idea to me.
If you want to use /dev/mem like this, don't enable the config option
to restrict it. Really.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
