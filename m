Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYJ0Q3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYJ0Q3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYJ0Q3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:29:30 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:41265 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYJ0Q33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:29:29 -0400
Date: Mon, 27 Oct 2008 09:27:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [GIT PULL/RESEND] kernel message catalog patches
Message-Id: <20081027092739.04b89526.randy.dunlap@oracle.com>
In-Reply-To: <20081027161923.GE10603@mit.edu>
References: <1224230354.4631.1.camel@localhost>
	<20081021092148.GB4980@osiris.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.0810230835150.3287@nehalem.linux-foundation.org>
	<20081023210446.GA12003@osiris.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.0810231433380.3287@nehalem.linux-foundation.org>
	<1225049195.14057.72.camel@localhost>
	<alpine.LFD.2.00.0810261212290.5200@nehalem.linux-foundation.org>
	<1225101688.15777.6.camel@localhost>
	<alpine.LFD.2.00.0810270750100.3386@nehalem.linux-foundation.org>
	<1225122726.15777.42.camel@localhost>
	<20081027161923.GE10603@mit.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4905EBF8.02D7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 12:19:23 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Oct 27, 2008 at 04:52:06PM +0100, Martin Schwidefsky wrote:
> > In that case ALL printk messages would suddenly grow a hash. Which
> > precludes the use of the component name as part of the message since we
> > would need to add a component name for every single printk - that won't
> > happen.
> 
> Just as a suggestion, what about adding the component name the same
> way we added the priority level --- i.e., by adding an optional
> prefix, say "{COMPONENT}" to the printk string, which would be before
> the urgency level marker.  If it's not present, printk can generate a
> 64-bit hash; if it is present, printk can generate the component name
> followed by a 32-bit hash.
> 
> That way we can gradually add component names in a completely
> backwards compatible way, and only to the device drivers that care or
> want it.
> 
> > > And as for the actual explanations: either they need to be totally outside 
> > > the kernel (in a project of their own), or they'd need to be "kernel-doc" 
> > > style things that are _in_ the source code. Not in Documentation/. Not 
> > > separate from the printk() that they are associated with.
> > 
> > The kmsg comments are already formatted in the kernel-doc style and you
> > can put the comment anywhere in the source file that contains the
> > printk. The Documentation/ is an extra path where the script looks for
> > the comments. I can easily drop that part. So yes, the concept is that
> > you can keep the message comment close to the printk.
> 
> I would think keeping the kmsg comments as kernel-doc style in the
> kernel source file makes a huge amount of sense.

As I said a few months ago, please make it "almost kernel-doc style"
but something that can be distinguished from the current kernel-doc.
They aren't quite the same thing AFAICT.

-- 
~Randy
