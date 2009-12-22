Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZLVP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZLVP2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZLVP2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:28:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZLVP2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:28:49 -0500
Date: Tue, 22 Dec 2009 16:28:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jbaron@redhat.com, mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
Message-ID: <20091222152824.GA20225@jolsa.lab.eng.brq.redhat.com>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
 <87ws0fcixd.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ws0fcixd.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 01:06:06PM +0100, Andi Kleen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > Hi,
> >
> > as I use dynamic debug sometimes, I thought it could be useful having
> > the possibility to store the output somewhere else than dmesg.
> >
> > The attached patch implements support for storing dynamic debug
> > messages to the ring buffer.
> >
> > The dynamic debug allows simple addition of new flags,
> > so I added 'r' flag for ring buffer storage.
> >
> > I used the ring buffer implementation from trace framework.
> >
> > hopefuly this could be any use for others as well...
> > plz let me know what you think,
> 
> The basic idea sounds good, but doing it all inline is a horrible 
> idea. That will bloat the kernel considerably because all
> users have to expand this code.
> 
> I would suggest to implement an out of line dyndebug_printk()
> which does all of this out of line.

right, I'll try to squeeze it

thanks,
jirka

> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
