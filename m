Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXCPS1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXCPS1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbXCPS1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:27:02 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbXCPS1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:27:00 -0400
Date: Fri, 16 Mar 2007 10:26:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: Linux 2.6.21-rc4
Message-Id: <20070316102650.267e2c55.akpm@linux-foundation.org>
In-Reply-To: <45FAD77A.1070709@googlemail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<45FAD77A.1070709@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 18:44:26 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> I've got *bad* news. Bug described here
> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#0889
> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> probably leaked into mainline. 
> 
> Fsck!

fsck indeed.  I don't even understand what's happening with that one - it
seems like the kernel schedules a user process, but never deschedules it
again.
