Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbZBZFnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbZBZFnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZBZFni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:43:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZBZFnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:43:37 -0500
Date: Thu, 26 Feb 2009 00:43:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
In-Reply-To: <20090225213641.1a0ff6f6.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902260042580.26792@gandalf.stny.rr.com>
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <49A5F81F.6060604@zytor.com> <20090225213641.1a0ff6f6.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Andrew Morton wrote:

> On Wed, 25 Feb 2009 18:02:07 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Steven Rostedt wrote:
> > > This patch creates a copy_word_from_user function that can copy
> > > a space delimited word from user space. This puts the code in
> > > a new lib/uaccess.c file. This keeps the code in a single location
> > > and may be optimized in the future.
> > 
> > I have a bit of an issue with the naming... at least *I* read this as 
> > copying a machine word, which made me wonder why you didn't just use 
> > "get_user".  I would suggest copy_token_from_user or something like that.
> > 
> 
> Yes, it set me back for a sec.  But anyone who uses the maddeningly
> vague concept of a "word" in an interface deserves to get their head
> boiled anyway, so there should be no confusion.

I'll remember to stay away from akpm if I see him heading my way with 
anything boiling in his hands.

-- Steve

