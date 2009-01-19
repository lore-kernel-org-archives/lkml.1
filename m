Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZASQ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZASQ2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZASQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:28:06 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57102 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZASQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:28:05 -0500
Date: Mon, 19 Jan 2009 17:29:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
Message-ID: <20090119162947.GA10378@uranus.ravnborg.org>
References: <1232370050-7434-1-git-send-email-avi@redhat.com> <20090119130927.GC6876@elte.hu> <49747C44.1030901@redhat.com> <20090119132214.GA20722@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119132214.GA20722@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> btw., would be nice to somehow untangle consciously-exported interface 
> definitions from kernel side bits, and standardize these 
> feature/capability flags like __KVM_HAVE_IOAPIC, etc.
> 
> Right now we have this body of 75,000 lines of code spread out in 600+ 
> header files that are so-called 'exported' to user-space, but 95% of that 
> interface definition code is never being relied on by any user-space bit! 
> They are exported due to cargo-cult mentality or due to dependencies.

With the exported headers we at least have a clear definition
what part of the headers are actually exported.
So what we have now is a much better base to cut off from.

And there is plenty of room for improvements but it requires
someone with understanding of the kernel side and the user side to do
this.

I for once find it hard to judge what is really used by user space and
not. Diving into glibc does not help as userspace is much more than
glibc although glibc is an important 'customer' here.

	Sam
