Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZBZFhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZBZFhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZBZFhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:37:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbZBZFhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:37:21 -0500
Date: Wed, 25 Feb 2009 21:36:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
Message-Id: <20090225213641.1a0ff6f6.akpm@linux-foundation.org>
In-Reply-To: <49A5F81F.6060604@zytor.com>
References: <20090225203007.582030664@goodmis.org>
	<20090225203427.382137706@goodmis.org>
	<49A5F81F.6060604@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 18:02:07 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> Steven Rostedt wrote:
> > This patch creates a copy_word_from_user function that can copy
> > a space delimited word from user space. This puts the code in
> > a new lib/uaccess.c file. This keeps the code in a single location
> > and may be optimized in the future.
> 
> I have a bit of an issue with the naming... at least *I* read this as 
> copying a machine word, which made me wonder why you didn't just use 
> "get_user".  I would suggest copy_token_from_user or something like that.
> 

Yes, it set me back for a sec.  But anyone who uses the maddeningly
vague concept of a "word" in an interface deserves to get their head
boiled anyway, so there should be no confusion.

