Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0BWPed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:34:33 -0500
Received: from kroah.org ([198.145.64.141]:35405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab0BWPec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:34:32 -0500
Date: Tue, 23 Feb 2010 07:34:12 -0800
From: Greg KH <greg@kroah.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Greg KH <gregkh@suse.de>, Serge Hallyn <serue@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Anton Blanchard <anton@samba.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Americo Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [29/93] fs/exec.c: restrict initial stack space
 expansion to rlimit
Message-ID: <20100223153412.GB4275@kroah.com>
References: <20100219163238.671588178@kvm.kroah.org>
 <11054.1266734564@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11054.1266734564@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 05:42:44PM +1100, Michael Neuling wrote:
> In message <20100219163238.671588178@kvm.kroah.org> you wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know
> .
> > 
> > ------------------
> > 
> > From: Michael Neuling <mikey@neuling.org>
> > 
> > commit 803bf5ec259941936262d10ecc84511b76a20921 upstream.
> > 
> > When reserving stack space for a new process, make sure we're not
> > attempting to expand the stack by more than rlimit allows.
> 
> This breaks UML, so you also need to take this also:
> 
>   http://patchwork.kernel.org/patch/79365/
> 
> It's in akpm's tree only so far.

As I can't take patches that are not in Linus's tree, can you let
stable@kernel.org know the git commit id of the patch when it goes into
Linus's tree, and then I will apply it to the next .32-stable release?

thanks,

greg k-h
