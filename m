Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZCEXCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZCEXCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZCEXCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:02:24 -0500
Received: from fifo99.com ([67.223.236.141]:35606 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZCEXCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:02:23 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 15:02:22 -0800
Message-Id: <1236294142.5937.88.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 17:54 -0500, Alan Stern wrote:
> On Thu, 5 Mar 2009, Daniel Walker wrote:
> 
> > Fix up some typos, and make the requirements section slightly cleaner.
> > 
> > Signed-Off-By: Daniel Walker dwalker@fifo99.com
> > 
> > diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
> > index 607b1a0..5b51aef 100644
> > --- a/Documentation/x86/earlyprintk.txt
> > +++ b/Documentation/x86/earlyprintk.txt
> > @@ -9,7 +9,9 @@ and two USB cables, connected like this:
> >  
> >  1. There are three specific hardware requirements:
> >  
> > - a.) Host/target system needs to have USB debug port capability.
> > + a.) You will need two USB ports. One on the client/console system and one one the target system.
> 
> s/one one/one on/

Check.

> You might also try harder to observe the 80-column rule.

I wasn't aware it applied to documents ..

> > + 
> > + b.) The client/console and target USB ports must have the debug port capability.
> >  
> >   You can check this capability by looking at a 'Debug port' bit in
> >   the lspci -vvv output:
> > @@ -35,15 +37,13 @@ and two USB cables, connected like this:
> >  ( If your system does not list a debug port capability then you probably
> >    wont be able to use the USB debug key. )
> >  
> > - b.) You also need a Netchip USB debug cable/key:
> > + c.) You also need a Netchip USB debug cable/key:
> >  
> >          http://www.plxtech.com/products/NET2000/NET20DC/default.asp
> >  
> >       This is a small blue plastic connector with two USB connections,
> >       it draws power from its USB connections.
> 
> No.  It draws power from one of its USB connections (the one on the 
> right side when you're looking at the face with the PLX logo).

I didn't write that part, but I suppose I could correct it..

Daniel

