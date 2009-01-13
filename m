Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZAMXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZAMXwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZAMXwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:52:15 -0500
Received: from gw.goop.org ([64.81.55.164]:49290 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZAMXwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:52:14 -0500
Message-ID: <496D292B.20007@goop.org>
Date: Tue, 13 Jan 2009 15:52:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove byte locks
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu> <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz> <20090112124401.GA31939@elte.hu> <496D1F54.7070104@goop.org> <alpine.LNX.1.10.0901140016520.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901140016520.5377@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Why can't this just be somewhere in documentation? (possibly even with the 
> byte locks code as a reference).
>   

Because Ingo's compil-o-matic will never fail on a documentation error.

> It is IMHO just totally confusing to have a spinlock implementation that 
> is not used at all in the tree. It took me quite some time to go through 
> this until I finally figured out that this code is actually never used. 
> Currently, on first sight it might seem that byte locks are used whenever 
> CONFIG_PARAVIRT is set, which is not true.
>   

Well, a comment next to the code explaining the rationale probably 
wouldn't go astray.

> And apparently even Linus got confused by this, which also tells us 
> something by itself, see [1].
>
> [1] http://marc.info/?l=linux-kernel&m=123144211719754&w=2
>   

It tells us that Linus couldn't give a rat's arse about virtualization, 
which is just something we have to cope with ;)

    J
