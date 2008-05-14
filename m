Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYENEpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYENEpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYENEpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:45:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36805 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbYENEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:45:23 -0400
Message-ID: <482A6E2B.4030806@zytor.com>
Date: Tue, 13 May 2008 21:44:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andi Kleen <andi@firstfloor.org>, Miklos Vajna <vmiklos@frugalware.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] x86: janitor work in bugs.c
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>	 <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>	 <87tzh17vy3.fsf@basil.nowhere.org> <1210724499.14967.78.camel@localhost>
In-Reply-To: <1210724499.14967.78.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2008-05-13 at 23:09 +0200, Andi Kleen wrote:
>> We had a discussion recently that wrapping printk format strings
>> is a bad idea. Don't do it please.
> 
> I don't know that there was a resolution either.
> http://lkml.org/lkml/2008/2/22/143
> 
> If there was one, there's a lot of possible changes.
> 
> $ grep -rP --include=*.[ch] "printk.*\"\s*$\s*\"" * | wc -l
> 13276
> 
> divide by 2, there are more than 6K split source line printks
> 

Perhaps a better idea would be to write a script to grep for strings.

	-hpa
