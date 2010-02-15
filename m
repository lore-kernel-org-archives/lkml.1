Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0BOVGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab0BOVGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:06:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
In-Reply-To: H. Peter Anvin's message of  Monday, 15 February 2010 12:43:46 -0800 <4B79B202.5090006@zytor.com>
References: <20100215161752.GA19962@redhat.com>
	<4B799C3F.7010308@zytor.com>
	<20100215194123.96D49FC3@magilla.sf.frob.com>
	<4B79B202.5090006@zytor.com>
X-Shopping-List: (1) Antagonistic friction
   (2) Contagious brunch commotions
   (3) Credulous holidays
   (4) Antic clasps
Message-Id: <20100215210539.B0D0B553@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 13:05:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, the origin of this is checkin
> 4d9bc79cd28b779610d9590b3a96a28a0f64a25a (2.6.18-rc1), which somewhat
> unhelpfully states "Make sure is_compat_task works early".  It doesn't
> specify what the failure is if is_compat_task doesn't work early.  

I can't figure out what could care.  Maybe at the time something else
tested it that doesn't do so now.

> On the other hand, it sure as heck seems better to set it and not need it
> than the other way around.

Agreed.


Thanks,
Roland
