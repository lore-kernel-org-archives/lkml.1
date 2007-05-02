Return-Path: <linux-kernel-owner+w=401wt.eu-S1767016AbXEBR6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767016AbXEBR6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767013AbXEBR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:58:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60045 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767007AbXEBR6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:58:32 -0400
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
From: john stultz <johnstul@us.ibm.com>
To: Peter Keilty <peter.keilty@hp.com>
Cc: Daniel Walker <dwalker@mvista.com>, linux-ia64@vger.kernel.org,
       Eric Whitney <eric.whitney@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <463220C8.5060408@hp.com>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
	 <1177621673.12796.121.camel@imap.mvista.com>  <46320ACD.6090704@hp.com>
	 <1177688158.12796.125.camel@imap.mvista.com>  <463219CD.5040203@hp.com>
	 <1177688931.12796.130.camel@imap.mvista.com>  <463220C8.5060408@hp.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 10:58:27 -0700
Message-Id: <1178128707.6183.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 12:11 -0400, Peter Keilty wrote:
> Daniel Walker wrote:
> >On Fri, 2007-04-27 at 11:42 -0400, Peter Keilty wrote:
> >>>There is a read(), and a vread() did you modify the slow syscall path to
> >>>use the vread()?
> >>> 
> >John mentioned that he thought fsys_mmio_ptr could be held in the vread
> >pointer. vread() is used in x86 for vsyscalls. It looks like you've used
> >the update_vsyscall() which is also used for vsyscalls. So vread could
> >also be used .. Have you considered that at all?
> >  
> >
> No, but yes it can be done, overloading the meaning.

Yea. I'm not really psyched about overloading the vread pointer's use. I
mentioned it could be done if the #ifdef was objected to, but it seems a
bit abusive. The #ifdef isn't great, but I think its something I can
live with for now. At least its explicit.

> It would need to change in the future if vread was needed.
> I have no strong argument against  using it.

Yea. I'd hold off on that for now.

thanks
-john


