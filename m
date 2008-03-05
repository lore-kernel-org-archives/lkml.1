Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYCEXxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYCEXxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYCEXxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:53:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60254 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760508AbYCEXxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:53:06 -0500
Date: Thu, 6 Mar 2008 02:52:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] send_sigqueue: don't forget about handle_stop_signal()
Message-ID: <20080305235237.GA6366@tv-sign.ru>
References: <20080305215314.GA3821@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305215314.GA3821@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Oleg Nesterov wrote:
>
> (on top of Pavel's signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch)
> 
> send_group_sigqueue() calls handle_stop_signal(), send_sigqueue() doesn't.
> This is not consistent and in fact I'd say this is (minor) bug.
> 
> Move handle_stop_signal() from send_group_sigqueue() to do_send_sigqueue(),
> the latter is called by send_sigqueue() too.

Sorry for the noise, but I forgot to mention that this patch of course depends
on signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch

Oleg.

