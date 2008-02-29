Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbYB2Q6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbYB2Q6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYB2Q6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:58:10 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33573 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbYB2Q6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:58:08 -0500
Date: Fri, 29 Feb 2008 08:58:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yannick <yannick.dirou@axetic.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug 10071] kernel hang in inet_init (PREEMPT_RCU problem)
Message-ID: <20080229165801.GD13330@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <bug-10071-11547@http.bugzilla.kernel.org/> <20080228205303.261D311D108@picon.linux-foundation.org> <20080228213457.GA2770@ami.dom.local> <20080229005823.GF14104@linux.vnet.ibm.com> <20080229043235.GA25167@linux.vnet.ibm.com> <47C7ABE3.6080004@axetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C7ABE3.6080004@axetic.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 07:53:23AM +0100, Yannick wrote:
> (In reply to comment #20)
> > Reply-To: paulmck@linux.vnet.ibm.com
> >
> > Would you be willing to try your test again after applying the
> > patch in http://lkml.org/lkml/2008/2/2/11 and rebuilding your
> > kernel?
> >
> > This patch does not appear to be in 2.6.25-rc3.  :-(
> >
> > I am reposting this patch separately.
> >
> >                                                         Thanx, Paul
> 
> Congratulations Paul and thanks a lot to Jarek , It works,
> no more hang or slow boot :
> [1.061675] Calling initcall 0xc03b8e10: inet_init+0x0/0x3ba()
> [1.061895] NET: Registered protocol family 2
> [1.339007] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [1.339470] TCP established hash table entries: 131072 (order: 8, 1048576 
> bytes)
> [1.340375] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
> [1.349809] TCP: Hash tables configured (established 131072 bind 65536)
> [1.349906] TCP reno registered
> [1.098514] initcall 0xc03b8e10: inet_init+0x0/0x3ba() returned 0.
> [1.098604] initcall 0xc03b8e10 ran for 32 msecs: inet_init+0x0/0x3ba()

Thank you very much for testing this, Yannick!

Andrew and Ingo have this patch on track to merge into a later -rc
of 2.6.25, so we will get there.  ;-)

						Thanx, Paul
