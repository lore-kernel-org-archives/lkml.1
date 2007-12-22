Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXLVN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXLVN1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXLVN1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:27:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:33995 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXLVN1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XpXsYsoTU2SPc1WNo/vmMSCKqZnEQAY3bZcwKmgIxphvikVy7re8OZwVqyAUF5S7Gxjdn74k4uembjmvRwDKV9uZQaArLzxwMpWdW2LRX1Nr+IvikIvGq1b5cAmwFGCdWxGxbGc+GtWWRn+vJyzkV3qCzb96a0S7lcg9WfNHA5A=
Message-ID: <84144f020712220527s6eb59746t88bd27f1bab24e1e@mail.gmail.com>
Date: Sat, 22 Dec 2007 15:27:03 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071222125454.GD14767@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	 <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
	 <20071222100326.GF26157@elte.hu>
	 <20071222123705.GA14767@one.firstfloor.org>
	 <84144f020712220451s87a3957i1f1c64a60c6a8473@mail.gmail.com>
	 <20071222125454.GD14767@one.firstfloor.org>
X-Google-Sender-Auth: 5fbda0397e04733e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Dec 22, 2007 2:54 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Yeah but then again removing an interface that has been around for
> > ever
>
> Version 2.1 hasn't been around forever and at least slabtop does not
> work over version number changes in my experience.

True but the default user-visible ABI (the one without statistics) is
unchanged since version 2.0:

http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=7ee832030b3a5d3a87f8f85b1fc773be15e98608

http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=e79fbf181ba738ca410f2c457ced220b738e8856

But anyway, I don't care too much either way so I'll just let Andrew
sort this out, as usual.

                                 Pekka
