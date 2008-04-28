Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbYD1QrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbYD1QrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933885AbYD1Qq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:46:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59079 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933596AbYD1Qq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:46:57 -0400
Date: Mon, 28 Apr 2008 18:46:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henry Nestler <Henry.Ne@Arcor.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
	2.6
Message-ID: <20080428164634.GC18210@elte.hu>
References: <480E6BB4.5080902@henry.nestler.gmail.com> <480E8069.20502@henry.ne.arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E8069.20502@henry.ne.arcor.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henry Nestler <Henry.Ne@Arcor.de> wrote:

> An other fix would be to copy the "fs_names+offset" into a new page 
> and give a page alignment buffer to do_mount_root. I feel it is better 
> to fix the fault handler for all failed addresses, not only the mount?

agreed - but this would be a VFS fix, Al Cc:-ed. I ran into that 
property of the mount string copy myself in the past.

(note, your patches were whitespace damaged - i fixed up the x86 fix by 
hand - you might want to resend the VFS one via 
Documentation/email-clients.txt.)

	Ingo
