Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbZJOWEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbZJOWEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbZJOWEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:04:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758175AbZJOWEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:04:39 -0400
Date: Thu, 15 Oct 2009 15:02:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>, alan@linux.intel.com,
       stable@kernel.org, stable-commits@vger.kernel.org, fredlwm@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: patch pty-quickfix-for-the-pty-enxio-timing-problems.patch added
 to 2.6.31-stable tree
In-Reply-To: <20091015215459.GA11142@suse.de>
Message-ID: <alpine.LFD.2.01.0910151502020.6146@localhost.localdomain>
References: <20091015184454.5BEDB48B35@coco.kroah.org> <alpine.LFD.2.01.0910151450420.6146@localhost.localdomain> <20091015215459.GA11142@suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Greg KH wrote:
> 
> Hm, ok, Marcin asked that I include this patch as it fixed his keyboard
> problems with X on 2.6.31.
> 
> Marcin, any ideas?

Get current -git, I think it shoul be fixed there properly.

Marking the pty's "low_latency" works around the problem, but will break 
at least ppp.

		Linus
