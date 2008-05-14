Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYENAWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYENAWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYENAW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:22:26 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3708 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbYENAW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:22:26 -0400
Subject: Re: [PATCH 2/3] x86: janitor work in bugs.c
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Miklos Vajna <vmiklos@frugalware.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87tzh17vy3.fsf@basil.nowhere.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
	 <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
	 <87tzh17vy3.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 13 May 2008 17:21:39 -0700
Message-Id: <1210724499.14967.78.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 23:09 +0200, Andi Kleen wrote:
> We had a discussion recently that wrapping printk format strings
> is a bad idea. Don't do it please.

I don't know that there was a resolution either.
http://lkml.org/lkml/2008/2/22/143

If there was one, there's a lot of possible changes.

$ grep -rP --include=*.[ch] "printk.*\"\s*$\s*\"" * | wc -l
13276

divide by 2, there are more than 6K split source line printks


