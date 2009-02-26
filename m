Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZBZCR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZBZCR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBZCRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:17:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZBZCRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:17:16 -0500
Date: Wed, 25 Feb 2009 21:17:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
In-Reply-To: <49A5F81F.6060604@zytor.com>
Message-ID: <alpine.DEB.2.00.0902252114090.12697@gandalf.stny.rr.com>
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <49A5F81F.6060604@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, H. Peter Anvin wrote:

> Steven Rostedt wrote:
> > This patch creates a copy_word_from_user function that can copy
> > a space delimited word from user space. This puts the code in
> > a new lib/uaccess.c file. This keeps the code in a single location
> > and may be optimized in the future.
> 
> I have a bit of an issue with the naming... at least *I* read this as copying
> a machine word, which made me wonder why you didn't just use "get_user".  I
> would suggest copy_token_from_user or something like that.

Hehe, I was going to use that name for the function that supplies that 
delimiter. But then we have the question. Should the delimiter be a single 
character. Do we allow any delimiter? Or simply pass in a function that 
will determine the delimiter?

-- Steve

