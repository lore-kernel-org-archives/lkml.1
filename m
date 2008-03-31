Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYCaKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYCaKU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYCaKUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:20:14 -0400
Received: from www.tglx.de ([62.245.132.106]:52855 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbYCaKUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:20:13 -0400
Date: Mon, 31 Mar 2008 12:19:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Martin Michlmayr <tbm@cyrius.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
In-Reply-To: <200803302106.42624.jwilson@redhat.com>
Message-ID: <alpine.LFD.1.10.0803311217550.3219@apollo.tec.linutronix.de>
References: <20080321153952.GA26354@deprecation.cyrius.com> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <200803302106.42624.jwilson@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Jarod Wilson wrote:
> > I tend to believe it is a problem to be addressed in the x86 platform
> > support, not a driver problem.
> >
> > I Cc'd some random x86 folk...  To rehash the issue:
> >
> >    - Controller: Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
> >      Board: PM965/GM965/GL960 based
> >      The R5C832 is known to work with ohci1394 according to
> >      http://hardware4linux.info/component/14348/ and other reports.
> 
> Its also known to work with the juju firewire stack -- that's the controller 
> in my own laptop, as well as a few other folks here in the office, all 
> running the new stack.

Hmm, can you please check whether you can reproduce the problem with
the original stack ?

Thanks,

	tglx
