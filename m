Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbZANXTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbZANXTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZANXTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:19:07 -0500
Received: from kroah.org ([198.145.64.141]:33756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756416AbZANXTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:19:05 -0500
Date: Wed, 14 Jan 2009 15:17:39 -0800
From: Greg KH <greg@kroah.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090114231739.GB24111@kroah.com>
References: <20090114010223.GA21380@kroah.com> <20090114021801.GA14759@bulgaria.corp.google.com> <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com> <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz> <20090114104834.18387fca@lxorguk.ukuu.org.uk> <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:26:48PM -0800, Arve Hjønnevåg wrote:
> On Wed, Jan 14, 2009 at 2:48 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Maybe our oom killer should get a new tunable, telling it how
> >> aggressive it should be, instead?
> >
> > I was thinking that, and it would integrate better with the OLPC work
> > (which IMHO is a nicer interface for some stuff)
> >
> > You'd want two thresholds
> >
> > The 'arghhhh....' point where you start killing stuff
> > The 'uh oh...' point where an OLPC style low memory notifier kicks in
> 
> We actually use 6 different thresholds for killing processes. I don't
> know what all the classes are, processes with a higher oom_adj value
> can be killed with less impact to the user than processes with a lower
> oom_adj value. The first few classes only affect latency when
> switching apps, but later classes stop non critical background
> services and finally the foreground app. Another reason to not kill
> every process at the same threshold is that memory may not be free
> immediately when the process is killed.

But the lowmemorykiller android module doesn't have anything to do with
this, right?

thanks,

greg k-h
