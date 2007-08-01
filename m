Return-Path: <linux-kernel-owner+w=401wt.eu-S1762373AbXHAIK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762373AbXHAIK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbXHAIKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:10:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756903AbXHAIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:10:43 -0400
Date: Wed, 1 Aug 2007 01:10:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: 2.6.23-rc1-mm2
Message-Id: <20070801011033.51679dd5.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<20070801062501.GB7581@linux-sh.org>
	<8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 03:58:48 -0400 "Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On 8/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
> > > - Is anyone testing the kgdb code in here?
> >
> > Testing, yes. Succeeding, no. It's utterly hosed on SH in its present
> > condition at least. Presumably it's been tested on at least one platform
> > with some measure of success, but it's certainly not mine ;-)
> 
> does kgdb actually have a chance to get merged ?

I was hoping for a 2.6.24 merge.  But I haven't actually looked at it yet. 
Hopefully Jason is planning to get it all out for review soonish.

>  with the history of
> it, i just assumed it was never going in, so we've been using our own
> kgdb patch on Blackfin ... so the version *we have* works great :) but
> if there's a chance of this actually going mainline, we can see about
> testing that version as well ...

Please, do so.

But runtime testing isn't actually the most important thing at this time -
if is doesn't work, well hey, we fix it, easy - we always have bugs.  The
main emphasis right now should be on higher-level design/review/integration
stuff.

