Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZGNSpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZGNSpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZGNSpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:45:50 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:40929 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZGNSpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:45:49 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 14:45:49 EDT
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Clock incorrect on 2.6.31-rc2
References: <20090709141000.584d199a@nehalam>
	<1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
	<20090709153855.6230729e@nehalam> <1247181779.3259.6.camel@work-vm>
	<20090709163055.115d5878@nehalam>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 14 Jul 2009 11:35:30 -0700
In-Reply-To: <20090709163055.115d5878@nehalam>
Message-ID: <87hbxfxgct.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:

> > I'm a little stumped.  Does the problem occur on every reboot? How long
> > does the box need to be up before you see an issue?  Or does it go away
> > after a little while?
> 
> It seemed to take a while (several hours). I will leave it running overnight

Interestingly, I am seeing the same problem on two boxes with
2.6.2{5,6}.  I haven't checked yet more recent kernels.

The odd thing was that booting with "nohz=off highres=off" did not
help, the only cure was to recompile the kernel and disable
CONFIG_HIGH_RES_TIMERS and CONFIG_NO_HZ.

This is the thread back then:
http://marc.info/?t=121563147700003&r=1&w=2

Phil.
