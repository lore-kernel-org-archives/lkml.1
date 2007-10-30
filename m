Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXJ3XtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXJ3XtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXJ3XtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:49:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28257 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXJ3XtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:49:09 -0400
Subject: Re: [PATCH -rt] remove in_interrupt() BUG_ON in exit path
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, kraj@mvista.com
In-Reply-To: <Pine.LNX.4.58.0710301939340.31349@gandalf.stny.rr.com>
References: <20071030224004.417523706@mvista.com>
	 <Pine.LNX.4.58.0710301939340.31349@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 16:43:16 -0700
Message-Id: <1193787796.4673.74.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 19:44 -0400, Steven Rostedt wrote:

> I did this change once before, while debugging. I had the same issue. This
> BUG_ON was giving me recursive crashes that prevented me knowing WTF was
> going on.  I thought I even submitted a patch to remove it. Perhaps I
> forgot to. Nope, I did!
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0707.0/1804.html

I wonder if Ingo had his reasons for keeping it.. They're may have been
a benefit to doing a BUG_ON at one point .. I don't know ..

Daniel

