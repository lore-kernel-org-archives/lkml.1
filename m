Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZANKn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZANKn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZANKnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:43:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33917 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZANKnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:43:17 -0500
Date: Wed, 14 Jan 2009 11:43:07 +0100
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Brian Swetland <swetland@google.com>,
       arve@google.com, San Mehat <san@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090114104307.GA20451@elf.ucw.cz>
References: <20090114010223.GA21380@kroah.com> <20090114021801.GA14759@bulgaria.corp.google.com> <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com> <20090114035237.GB16442@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114035237.GB16442@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 19:52:37, Greg KH wrote:
> On Tue, Jan 13, 2009 at 06:30:39PM -0800, Arve Hj?nnev?g wrote:
> > The oom killer does not kick in until all caches are emptied. Our user
> > space code changes the oom_adj value of processes that are no longer
> > in the foreground so that they killed first (the process saves its
> > state but does not exit). To avoid excessive demand paging, the low
> > memory killer will kill these processes when the memory available
> > drops below a threshold.
> 
> That makes sense.  Can you provide a bit of documentation that I can
> include in the driver so that people can actually use the thing?  :)
> 
> Alan, does this sound like it should remain in the tree?

Maybe our oom killer should get a new tunable, telling it how
aggressive it should be, instead?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
