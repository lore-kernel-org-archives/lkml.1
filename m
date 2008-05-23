Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYEWMDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYEWMDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYEWMDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:03:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYEWMDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:03:33 -0400
Date: Fri, 23 May 2008 14:11:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080523121154.GH31727@one.firstfloor.org>
References: <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com> <20080523014855.GA18385@linux-os.sc.intel.com> <48362FD0.9030104@zytor.com> <18486.44689.203792.818972@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18486.44689.203792.818972@harpo.it.uu.se>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 01:46:25PM +0200, Mikael Pettersson wrote:
> H. Peter Anvin writes:
>  > Michael, you wrote:
>  > 
>  > > Hmm, right now it seems this field has a de-facto ABI of being
>  > > either 0xffff (plain) or 0x0000 (fxsr). Using other values would
>  > > confuse at least one application I know of. Sad.
>  > 
>  > ... could you share what application that is?  This otherwise would be 
>  > ideal.
> 
> It's the virtual machine for the Erlang/OTP concurrent functional
> language. It's open-source and used extensively for telecom and
> internet server applications.

I had a few reports over the years of other applications ddoing very weird 
specific things with the sigframe. So I agree it's fairly important
to be as compatible here as possible.

-Andi
