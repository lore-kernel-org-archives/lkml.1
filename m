Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966778Ab0B0BFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:05:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966750Ab0B0BFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:05:03 -0500
Date: Fri, 26 Feb 2010 17:04:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep
  (w. timeout) until wake_up
In-Reply-To: <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002261701230.4513@localhost.localdomain>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com> <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Feb 2010, Rafał Miłecki wrote:
>
> Following macro is soemthing that seems to work fine for us, but instead
> introducing this to radeon KMS only, I'd like to propose adding this to whole
> wait.h. Do you this it's something we should place there? Can someone take this
> patch for me? Or maybe you find this rather useless and we should keep this
> marco locally?

This does not smell generic to me. In fact, it makes me personally think 
you're doing something wrong in the first place, but maybe it's ok. But in 
case it really is ok, I'd still not put it in a generic header file unless 
you can point to other cases where it really makes sense to do this.

		Linus
