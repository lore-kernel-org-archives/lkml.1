Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZLMVY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZLMVY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZLMVY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:24:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:13135 "HELO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750730AbZLMVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:24:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fmgne/9BFetu/5ZRvkjXvDnb4pmNr45zEP2mOoD1OGGDbxgluLsqDFJyGTTy4EvI+N
         lcEqSp1m7sgct6XDt68DY3CSIomZXknfzh1DkbVUrro3bFixsDFEyn728xeVXm/zPdMM
         BuugmOzVmsES0zcyFgD9fBt2uKedbip2zxvpg=
Date: Sun, 13 Dec 2009 22:24:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] ftrace.h: Use common pr_info fmt string
Message-ID: <20091213212450.GB5220@nowhere>
References: <1260651974.2637.4.camel@Joe-Laptop.home> <tip-4819568f23a8bef0ca99b740ca60fe2450ab0aac@git.kernel.org> <1260715695.2146.412.camel@gandalf.stny.rr.com> <20091213145056.GA5268@nowhere> <1260729207.8189.56.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260729207.8189.56.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 10:33:27AM -0800, Joe Perches wrote:
> On Sun, 2009-12-13 at 15:50 +0100, Frederic Weisbecker wrote:
> > On Sun, Dec 13, 2009 at 09:48:15AM -0500, Steven Rostedt wrote:
> > > >  		pr_info("event trace: Could not activate trace point "	\
> > > > -			"probe to " #call "\n");			\
> > > > +			"probe to %s\n", #call);			\
> > > This reduces format string space a bit, but doesn't it just add another
> > > string to the string tables #func == "func" as well as add code to pass
> > > in another parameter?
> > Yeah, I don't understand the purpose of this patch either...
> 
> The patch from Li Zefan you've already queued is better
> 
> http://lkml.org/lkml/2009/12/13/60


Ok. Thanks.

