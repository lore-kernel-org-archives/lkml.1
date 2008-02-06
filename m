Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYBFQgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYBFQgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYBFQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:36:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:32428 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYBFQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=o5Qkf3VlKTSIRP7i9NHC68Ut39rDdlqY0sz8H69nKtf000rr8nNUHIecijHSIvmWOCBCuJvgfix6QuBqafgA1c5Bsn+atKXq1PIP9WS+On6JOMPkRcoFm9pnSeNtwMDQuWmJlydPH+fzYuyT9CHXo4OAoXVj88Sx1qX5/Z8l9Pw=
Date: Wed, 6 Feb 2008 17:36:36 +0100
To: Jiri Kosina <jikos@jikos.cz>
Cc: Chris Holvenstot <cholvenstot@comcast.net>,
       Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git15 Keyboard Issue?
Message-Id: <20080206173636.23f81913.Kristoffer.ericson@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
References: <1202302978.9058.13.camel@popeye>
	<Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	<1202305740.9058.22.camel@popeye>
	<Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 14:54:21 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Wed, 6 Feb 2008, Chris Holvenstot wrote:
> 
> > On this system I am using a PS2 Keyboard - and let me stress that it is 
> > only occasionaly that it happens - I have had 2.6.24-git15 up for about 
> > 2 hours now and have only seen it about a dozen times. I also note one 
> > other thing - although my system is lightly loaded - at this time of day 
> > I am pretty much just using email on an AMD 64 X2 4600+ with 2 gigs of 
> > of memory - I have noticed several times that I will be typing away and 
> > nothing is appearing on the screen - and a few seconds later - boom - 
> > there it all is.
> 
> It could be some timing problem. Does this happen also in console, or 
> only when running X?
> 
> Could you please try to
> 
> - boot with 'nohpet' kernel parameter
> - taskset -p 0x00000002 <pid_of_Xserver> if this is a multi-CPU/core 
>   machine and you are experiencing the problems only in X
> 

Perhaps something to CC linux-input on?

> Thanks,
> 
> -- 
> Jiri Kosina
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
