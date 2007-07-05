Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbXGEXc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbXGEXc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXGEXcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:32:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbXGEXcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:32:20 -0400
Date: Thu, 5 Jul 2007 16:32:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull][resend] Input updates for 2.6.22-rc7
In-Reply-To: <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0707051618040.9434@woody.linux-foundation.org>
References: <200707050111.43327.dtor@insightbb.com>
 <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Linus Torvalds wrote:
> 
> It says your user-agent is "Kmail", and maybe there is some way to fix it. 
> And if kmail is correct, please make a bug-report to the kmail people. 

Ok, googling for kmail, I think it really is kmail doing it, because I 
find others complaining about the same idiocy.

Btw, the others who noticed this weren't _nearly_ as polite as I am about 
kmail.

Apparently kmail - at least when cutting-and-pasting - will actually turn 
every other space into an NBSP for some internal idiotic reason. So even 
if you _originally_ had 8 spaces, Kmail will apparently corrupt your data 
when cutting-and-pasting according to that other report I saw.

Please stop using kmail, or ask for it to get fixed.

I'm constantly surprised by just how _many_ ways MUA's find to screw up. 
It's not like they seem to all have some stupid bug. It's more like they 
seem to all have willfully added code explicitly to mess up the content of 
email, often with the goal of making it "look" right, even if it's crap.

In this case, it means that you cannot cut-and-paste simple ASCII text, 
because Kmail messed up.

			Linus
