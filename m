Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYILXxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYILXxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYILXxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:53:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbYILXxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:53:37 -0400
Date: Fri, 12 Sep 2008 16:52:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: herton@mandriva.com.br, me@bobcopeland.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       bogdano@mandriva.com.br, lcapitulino@mandriva.com.br,
       draconux@gmail.com, dlallement@mandriva.com, pterjan@mandriva.com,
       axboe@kernel.dk
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
Message-Id: <20080912165222.9ed7fc25.akpm@linux-foundation.org>
In-Reply-To: <200809121646.09641.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
	<200809121807.28345.herton@mandriva.com.br>
	<20080912163650.0f85a759.akpm@linux-foundation.org>
	<200809121646.09641.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 16:46:08 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Friday 12 September 2008, Andrew Morton wrote:
> > ________________________________________________printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> > ________________________________________________________________disk->disk_name, p);
> > -______________________________________________continue;
> > ________________________________}

wtf-your-email-client-is-insane.

> So that now deserves to be KERN_WARN not KERN_ERR, yes?

spose so.

I'm fairly unenthused about the recent KERN_correctness fad since it
went and broke sysrq-T output (you have to set the loglevel beforehand
to avoid getting only partial output).


