Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZA3IU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZA3IU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZA3IUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:20:45 -0500
Received: from relay.atmel.no ([80.232.32.139]:55412 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZA3IUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:20:44 -0500
Date: Fri, 30 Jan 2009 09:20:25 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-ID: <20090130092025.618fa78f@hcegtvedt>
In-Reply-To: <20090129155042.e0ea148d.akpm@linux-foundation.org>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<20090129174655.1f440f3e@hcegtvedt>
	<20090129155042.e0ea148d.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 15:50:42 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 29 Jan 2009 17:46:55 +0100
> Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> 

<snipp>

> > Bump, or did I miss the merge window?
> > 
> 
> (Top-posting repaired.  Please don't do that!  It makes it horrid to
> reply to you)
> 

Sorry, I'll do a resend of the original email instead next time. I had
the idea about the initial email would be picked up.

> (Suitable cc's added - this was why your patch got lost)
> 

AFAICT the lkml is the place for the drivers/misc stuff. Should I be
looking in another file than MAINTAINERS?

> The patch seems reasonable but the changelog seems to be quite
> misleading.  I did this:
> 
>    The ssc pointer is not valid when the id is not found in the
>    list.  Convert the message from a debug one into an error message
>    and avoid dereferencing the bad pointer.
> 
> OK?

Sounds way better than my Norwegian English, thanks (-:

-- 
Best regards,
Hans-Christian Egtvedt
