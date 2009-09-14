Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZINVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZINVUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZINVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:20:44 -0400
Received: from fifo99.com ([67.223.236.141]:59618 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbZINVUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:20:43 -0400
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
From: Daniel Walker <dwalker@fifo99.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
	 <1252961412.11643.215.camel@desktop>
	 <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com>
	 <1252962263.11643.232.camel@desktop>
	 <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 14:21:32 -0700
Message-Id: <1252963292.11643.259.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 17:07 -0400, Mike Frysinger wrote:
> On Mon, Sep 14, 2009 at 17:04, Daniel Walker wrote:
> > On Mon, 2009-09-14 at 16:57 -0400, Mike Frysinger wrote:
> >> On Mon, Sep 14, 2009 at 16:50, Daniel Walker wrote:
> >> > On Mon, 2009-09-14 at 16:07 -0400, Mike Frysinger wrote:
> >> >> Minor highlights:
> >> >>  - shadow console to help with really early kernel output
> >> >>  - proper decoding of double fault handling
> >> >>
> >> >> Otherwise, we've got the normal bug fixes, IPIPE updates, and clean ups.
> >> >>
> >> >
> >> > Patches 15, 16, 20, 21, and 61 all have checkpatch errors some with
> >> > several errors..  Could you clean those up those errors before sending
> >> > this up stream?
> >>
> >> i already checked/reviewed the output in the series
> >
> > The remaining problems can be fixed .. Why did you leave those errors ?
> 
> i'm not going to sweat 80 col warnings when the line is 81 cols with
> tabs of 8 spaces

The line length ones I'm not worried about, those are just warnings..

> as for the other errors, you probably didnt read the code.  you saw
> "error" and assumed checkpatch was correct.  it isnt always as it isnt
> a C parser.

Checkpatch is finding real issues with your patches.. You have
indentations issues in several of the patches. Your removing good
formatting and replacing it improper formatting. For instance,

ERROR: code indent should use tabs where possible
#115: FILE: arch/blackfin/kernel/module.c:102:
+^I^I           (!strcmp(".bss", shname) &&$

The line your removing had the proper formatting, but this new line has
improper formatting.. You have several of these issues, you must think
they aren't important but checkpatch has the WARNING and ERROR
classification for a reason .. The errors are actual style violation
that really need to be either cleaned up or explained..

They can be trivially fixed, it's just a matter of adding the proper
indentation ..

Daniel

