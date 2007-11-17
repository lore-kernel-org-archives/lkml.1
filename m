Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbXKQWtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbXKQWtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 17:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXKQWtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 17:49:25 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:55082 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXKQWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 17:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PLQm42pkwONd/Dw/Jx+DaxN//GpqGfnjaOYrLYdAgJHQO8Qq/WavPpEmwM3OM21JRCYkvjnXwpW5lnBi/I2pqss6w9hsgZFrgyJKRXPLXEYVEvx0J53i3XBWLd3bMKD6eccJsUS5eBex9/ukmuHEXo7fmzWoer+VGjIbOpBZppo=
Message-ID: <3efb10970711171449q3907b9a8r91d94832fb5ba701@mail.gmail.com>
Date: Sat, 17 Nov 2007 23:49:23 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Ingo Molnar" <mingo@elte.hu>, "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071117180430.GA10768@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu>
	 <1195322141.25393.41.camel@imap.mvista.com>
	 <20071117180430.GA10768@elte.hu>
X-Google-Sender-Auth: e4ade75569aec4dc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Sure, you want to split the list?
>
> split the list with you? Feel free to take any of those :-) dev->sem is
> nontrivial and probably not possible right now - and some of the others
> might be problematic too. But there might be fixable ones in the list.
> This shouldnt become like the BKL conversion - never truly finished.

Hey Ingo and Daniel, Leave some of the fun open for me :-)

I just looked at the list and I found a few that seem doable.


Remy
