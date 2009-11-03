Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZKCH0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZKCH0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZKCH0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:26:06 -0500
Received: from www84.your-server.de ([213.133.104.84]:43020 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbZKCH0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:26:06 -0500
Subject: Re: [PATCH] fix X86_64 procfs provide stack information for threads
From: Stefani Seibold <stefani@seibold.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091103055847.GA10629@hack.redhat.com>
References: <1257158829.5199.26.camel@wall-e>
	 <20091103055847.GA10629@hack.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 Nov 2009 08:26:05 +0100
Message-ID: <1257233165.22553.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 03.11.2009, 13:58 +0800 schrieb Américo Wang:
> On Mon, Nov 02, 2009 at 11:47:09AM +0100, Stefani Seibold wrote:
> >--- linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
> >+++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-02 10:39:47.177909657 +0100
> >@@ -29,6 +29,7 @@
> > #include <linux/threads.h>
> > #include <linux/math64.h>
> > #include <linux/init.h>
> >+//#include <linux/sched.h>
> 
> Hey, what is this? :)
> 
Garbage :-( I will resend the patch without!

> Except this, this patch looks fine for me:
> 
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


