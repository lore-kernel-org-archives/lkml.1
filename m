Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZGOW56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZGOW56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZGOW56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:57:58 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40706 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbZGOW55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:57:57 -0400
Subject: Re: Clock incorrect on 2.6.31-rc2
From: john stultz <johnstul@us.ibm.com>
To: Philippe Troin <phil@fifi.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <87hbxfxgct.fsf@old-tantale.fifi.org>
References: <20090709141000.584d199a@nehalam>
	 <1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
	 <20090709153855.6230729e@nehalam> <1247181779.3259.6.camel@work-vm>
	 <20090709163055.115d5878@nehalam>  <87hbxfxgct.fsf@old-tantale.fifi.org>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:57:15 -0700
Message-Id: <1247698635.7511.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 11:35 -0700, Philippe Troin wrote:
> Stephen Hemminger <shemminger@vyatta.com> writes:
> 
> > > I'm a little stumped.  Does the problem occur on every reboot? How long
> > > does the box need to be up before you see an issue?  Or does it go away
> > > after a little while?
> > 
> > It seemed to take a while (several hours). I will leave it running overnight
> 
> Interestingly, I am seeing the same problem on two boxes with
> 2.6.2{5,6}.  I haven't checked yet more recent kernels.

I suspect your issue and Stephen's issue are separate. 

> The odd thing was that booting with "nohz=off highres=off" did not
> help, the only cure was to recompile the kernel and disable
> CONFIG_HIGH_RES_TIMERS and CONFIG_NO_HZ.
> 
> This is the thread back then:
> http://marc.info/?t=121563147700003&r=1&w=2

Thomas, did you ever take a look at this? It looks like something's off
w/ hrt.

thanks
-john

