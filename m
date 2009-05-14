Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZENV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZENV6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZENV6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:58:42 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59760 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753601AbZENV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:58:41 -0400
Date: Thu, 14 May 2009 17:30:02 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: David Rientjes <rientjes@google.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <1242335120.15391.242.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0905141729180.30187@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>  <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>  <alpine.DEB.1.10.0905121708470.14226@qirst.com>  <20090514092909.GG1365@ucw.cz>  <alpine.DEB.1.10.0905141546040.1381@qirst.com>
  <1242333519.15391.210.camel@nimitz>  <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Dave Hansen wrote:

> -	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
> +	printk(KERN_ERR "No available memory %s: "
> +			"kill process %d (%s) score %li or a child\n",
>  					message, task_pid_nr(p), p->comm, points);

"No available memory" still suggests that plugging in more memory is the
right solution.

