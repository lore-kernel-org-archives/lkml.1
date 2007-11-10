Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbXKJQOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbXKJQOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 11:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXKJQN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 11:13:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:39565 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbXKJQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 11:13:58 -0500
To: jean-francois simon <jfs@themis.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Initrd problem with AMD opteron dual core
From: Andi Kleen <andi@firstfloor.org>
References: <4731630B.2050007@themis.com>
Date: Sat, 10 Nov 2007 17:13:56 +0100
In-Reply-To: <4731630B.2050007@themis.com> (jean-francois simon's message of "Wed\, 07 Nov 2007 08\:02\:35 +0100")
Message-ID: <p73ir4a13jv.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jean-francois simon <jfs@themis.com> writes:

> i don't know where to start to try solving this problem. why would the
> dual core CPUs cause a problem? i fear that just disabling the initrd
> could just mask a more serious problem.

Most likely.

> also i don't understand why /proc/meminfo only reports 1GB...

I would compare the e820 maps between single and dual core. Perhaps the
initrd happens to be loaded somewhere where it overwrite other memory.

Another reason could be broken MTRRs not covering all memory correctly.
This can cause strange mmeory corruptions

Also if single core is an old stepping memory remapping might work
differently.

-Andi
