Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZCQKMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZCQKMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZCQKM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:12:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38854 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZCQKMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:12:25 -0400
Date: Tue, 17 Mar 2009 19:12:16 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate() against SMI.
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
In-Reply-To: <49BE215F.7040307@ladisch.de>
References: <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com> <49BE215F.7040307@ladisch.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090317185152.47CD.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.01 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for late response.

> Yasunori Goto wrote:
> > > I've no sense of feel for how long each calibration run would take.
> > > Would doing it 5 times show up as a significant increase in the boot
> > > time for those that care about boot time being as quick as possible?
> > 
> > Hmm. The loop times is trade off against reliable value....
> > Though SMI is rare interruption, I don't know how frequent
> > hypervisor's switch is.
> 
> Could you, just for testing, run the calibration five thousand times or
> so instead of five times, and count how often you get insane values?
> (And how much delay does such an SMI add?)

I tried 50000 times. But insane value was nothing.
I think SMI is very rare.

> > Each calibration of this has 1 milli second.
> > Do you think 5 msec is too long?
> 
> This shouldn't matter when booting.  Anyway, I think it's possible to
> increase TICK_CALIBRATE without losing too much accuracy.

Hmm. If the person who is trying to reduce boot time for fastboot dislikes this impact,
then I'll try Vojtech-san's way.


Thanks.
-- 
Yasunori Goto 


