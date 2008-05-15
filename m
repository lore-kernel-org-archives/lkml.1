Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbYEOOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbYEOOyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYEOOyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:54:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:62743 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbYEOOyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=sIVqkTfKa148tod+ty/KkDAsh3hQoLpxBcQcgdbo+HXkGWIiB+d2YhFZQPtysZitflYE+z5WunK1oqptoyM0jNx/v6zF43V0v8q6f2YXYG9/6wYEdg/JwY7yP45Utah33uirtBTmHWYSDh2s2PBXQ/AZjbYF0GGtnF9dXxCSOgw=
Date: Thu, 15 May 2008 16:54:03 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-Id: <20080515165403.ce36f00e.diegocg@gmail.com>
In-Reply-To: <alpine.LNX.1.10.0805151041380.16151@fbirervta.pbzchgretzou.qr>
References: <6457.1210801515@vena.lwn.net>
	<alpine.LNX.1.10.0805151041380.16151@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 15 May 2008 10:44:57 +0200 (CEST), Jan Engelhardt <jengelh@medozas.de> escribió:

> 1b: add a .locked_open and move all BKL-requiring code to use that.
> When time comes and BKL is gone, .locked_open can be removed again,
> and no rename was ever done for BKL-free code.

1c: make the BKL-unsafe drivers depend on !SMP && !PREEMPT.
