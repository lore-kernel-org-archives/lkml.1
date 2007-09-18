Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXIRIgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXIRIgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXIRIfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:35:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:42693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbXIRIfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:35:52 -0400
To: Linux on Alpha processors <axp-list@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jay Estabrook <jay.estabrook@hp.com>,
       ac-admin@lists.anotherbloody.com
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at>
From: Andi Kleen <andi@firstfloor.org>
Date: 18 Sep 2007 10:35:50 +0200
In-Reply-To: <46EEE483.4020209@linux-kernel.at>
Message-ID: <p734phsxteh.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Falk <oliver@linux-kernel.at> writes:

> At Alphacore we used to patch the kernel headers for a while now; We
> added syscalls __NR_openat (447) until __NR_tee (466).
> 
> However, since 2.6.23 these syscall where added upstream, but with
> different syscall numbers; What happens is the following:
> 
> * glibc 2.6.90 compiled with 2.6.23 headers installed
> * kernel 2.6.21 (our patched headers in place, different syscall
> 'ordering'/numbers) installed
> 
> [root@tyskie ~]# uname -r; touch x; rm -f x
> 2.6.23-0.145.rc4.fc8
> rm: cannot remove `x': File exists
> 
> :-( I don't want to live without rm :-P and chmod doesn't work as well...

It's all your own fault. Only mainline can assign syscall numbers.
See it as a learning experience. Next time when you assign them
you shouldn't use them before the patch has reached mainline.

-Andi
