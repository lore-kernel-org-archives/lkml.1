Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYK0Xc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYK0Xc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 18:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYK0Xct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 18:32:49 -0500
Received: from styx.suse.cz ([82.119.242.94]:55379 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752393AbYK0Xct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 18:32:49 -0500
Date: Fri, 28 Nov 2008 00:32:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ron <ron@debian.org>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add missing printk loglevel
In-Reply-To: <20081126160157.GC28153@homer.shelbyville.oz>
Message-ID: <alpine.LNX.1.10.0811280032210.19853@jikos.suse.cz>
References: <20081126160157.GC28153@homer.shelbyville.oz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Ron wrote:

> -		printk("start_kernel(): bug: interrupts were enabled early\n");
> +		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
> +				 "enabled early\n");

Applied to trivial patches tree, thanks.

-- 
Jiri Kosina
