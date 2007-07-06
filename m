Return-Path: <linux-kernel-owner+w=401wt.eu-S1761679AbXGFEGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbXGFEGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 00:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbXGFEGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 00:06:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbXGFEGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 00:06:37 -0400
Date: Thu, 5 Jul 2007 21:06:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull][resend] Input updates for 2.6.22-rc7
In-Reply-To: <200707052340.42226.dtor@insightbb.com>
Message-ID: <alpine.LFD.0.98.0707052101170.9434@woody.linux-foundation.org>
References: <200707050111.43327.dtor@insightbb.com>
 <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
 <200707052340.42226.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Dmitry Torokhov wrote:
> 
> I was not... The copy I got from LKML looks fine in Kmail, Gmail and
> MS Outlook.                           ^^^^^^^^^^

That's the problem.

It *looks* *fine*.

The "&nbsp" doesn't look any different from a regular space. There's no 
way to tell the difference. Except it doesn't *work* the same. You 
cut-and-paste it into a shell window, and that shell window will not 
consider a nbsp to be the same thing as a space.

And I don't really understand why Kmail would do something like that. They 
obviously do it on purpose, since the nbsp wasn't there originally, so 
they literally go do extra work to _corrupt_ the data they cut-and-paste. 
Why do it? Who knows. But it's really sad.

			Linus
