Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab0CMWRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 17:17:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0CMWRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 17:17:38 -0500
Date: Sat, 13 Mar 2010 14:16:45 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [141/145] KVM: x86 emulator: Check CPL level
	during privilege instruction emulation
Message-ID: <20100313221645.GA21225@suse.de>
References: <20100313002717.508317046@kvm.kroah.org> <1268512677.2664.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268512677.2664.23.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 08:37:57PM +0000, Ben Hutchings wrote:
> On Fri, 2010-03-12 at 16:27 -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ----------------
> > From: Gleb Natapov <gleb@redhat.com>
> > 
> > commit e92805ac1228626c59c865f2f4e9059b9fb8c97b upstream.
> > 
> > Add CPL checking in case emulator is tricked into emulating
> > privilege instruction from userspace.
> 
> There were more security fixes released along with this, which surely
> belong in a stable update:
> 
> 1871c6020d7308afb99127bba51f04548e7ca84e KVM: x86 emulator: fix memory access during x86 emulation
> f850e2e603bf5a05b0aee7901857cf85715aa694 KVM: x86 emulator: Check IOPL level during io instruction emulation
> d4c6a1549c056f1d817e8f6f2f97d8b44933472f KVM: x86 emulator: Fix popf emulation

Yes, there were a number of kvm patches that I could not apply either
because they did not apply, or because they caused build errors.  These
are some of them.  I have asked the KVM developers to properly backport
them as I know nothing about KVM.  Hopefully that will be done for the
next round of stable releases.

thanks,

greg k-h
