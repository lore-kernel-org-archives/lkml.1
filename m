Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbZC3WI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbZC3WI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbZC3WIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:08:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:44158 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZC3WIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FXbUSK06vjSXlRpa/MpqWfg8ugg+5W1gbGC87k6j/YG22jRBhQvmIgoLRDWxQA5yPq
         1E8AFlG4Gz/K929W3YoKew2++wHFUmHzI1ywre62pXWs0iPw2cjcFc8pUhyZ8W+9IuP+
         t6bzrPmQ3Wmxh7NWgb1x26/28iiBQ5c9JNGmE=
Date: Tue, 31 Mar 2009 02:16:16 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090330221616.GA28060@x200.localdomain>
References: <20090329175642.GA26405@x200.localdomain> <20090329232422.GA9873@elte.hu> <20090329234839.GL28946@ZenIV.linux.org.uk> <20090330011355.GA11087@elte.hu> <20090330013355.GO28946@ZenIV.linux.org.uk> <20090330014926.GA32139@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330014926.GA32139@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:49:26AM +0200, Ingo Molnar wrote:
> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Mon, Mar 30, 2009 at 03:13:55AM +0200, Ingo Molnar wrote:
> > 
> > > There is simply no excuse for ever having let that crap get there 
> > > into fs/proc/base.c. There is no excuse for ever letting that crap 
> > > grow. The fact that that crap is there is proof of systemic failure 
> > > over the years to keep that code clean.
> > 
> > Nothing like proof by assertion, eh?
> 
> The proof is what i quoted - see below the full dump again. Those 
> are bona fide evidence of unclean code.
> 
> > > I dont really want to see "real work" done on code that was not 
> > > properly and cleanly finished in the first place.
> > 
> > Tough.  At the moment we have a rather unpleasant hole with 
> > tentative fix that touches fs/proc/base.c.  Whether you want said 
> > work postponed until all whitespace wanking is done on file in 
> > question or not, I simply don't give a damn - getting rid of real 
> > bug takes precedence.  Whitespace crap should be dealt with as we 
> > go through the functions containing such crap, religious bullshit 
> > nonwithstanding.
> 
> I am profoundly surprised that something as lightweight and simple 
> as a cleanup patch can make life difficult to you at all. How are 
> you handling them? Have you ever tried?
> 
> > And I very much object against completely unfounded assertions 
> > claiming that checkpatch noise makes a useful proxy for code 
> > quality.  You keep making those again and again, without a shred 
> > of evidence to show.
> 
> You dont have to take my word for it. Look at the output below. 
> Check the code. Compare to the CodingStyle. If it does not match, 
> then it's unclean code that should have been rejected when it got 
> there. Some of that is ancient code, some of that is recent code.
> 
> It might be perfectly fine code otherwise, i made no assertion about 
> the quality of other code in that area.
> 
> 	Ingo
> 
> ---------------->
> ERROR: space required before the open parenthesis '('
> #154: FILE: proc/base.c:154:

I'm finally convinced you do not understand what's going on in this
thread and previous threads on the subject and quitting. There will be
C/R stuff because I already promised and nothing more.
