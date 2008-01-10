Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYAJTyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYAJTyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYAJTy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:54:28 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:22265 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbYAJTy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:54:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UDfO4MaTORXF82l4T4htOqfFMDKYL1tYCK75DDa3lvlqf395+qeHawL33kKCZ0hpuUb/iG1Ogtvlza0YpX8HcLO3iQfsjoPRbDSYRRE4IfY8xRNLsIZnX9C/RF5nrJzKdBDks8Xq7BqpSDTbsJ1KKd5RtzALKWd8mnwPSwmB2GU=
Message-ID: <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
Date: Thu, 10 Jan 2008 11:54:23 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "john stultz" <johnstul@us.ibm.com>
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long delays
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tim Bird" <tim.bird@am.sony.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <1199923219.6350.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
	 <1199923219.6350.16.camel@localhost.localdomain>
X-Google-Sender-Auth: c79f5af89dc3052f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony:  ia64 also needs something like this, but I found the fsyscall asm
> bits a little difficult to grasp. So I'll need some assistance on how to
> include the accumulated cycles into the final calculation.

I'm trying to figure out all the ramifications of the new
"cycle_accumulated" field.  Does it really need to be
propagated all the way to the low level assembler (which
I don't want to mess with unless I really, really have to).
Can't I do the necessary calculations in update_vsyscall()
[Where I can do them in C :-)] and keep the same low
level assembly code.  I think I must be missing some
important bit of what is going on here.

-Tony
