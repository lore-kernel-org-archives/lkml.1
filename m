Return-Path: <linux-kernel-owner+w=401wt.eu-S1030755AbXDULvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755AbXDULvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030761AbXDULvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:51:33 -0400
Received: from 1wt.eu ([62.212.114.60]:2065 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030673AbXDULvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:51:32 -0400
Date: Sat, 21 Apr 2007 13:51:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070421115114.GB6383@1wt.eu>
References: <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu> <20070419184534.GA29096@1wt.eu> <20070421103129.GA12621@elte.hu> <20070421104522.GA17856@elte.hu> <20070421110748.GA6383@1wt.eu> <20070421112941.GA22432@atjola.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070421112941.GA22432@atjola.homenet>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Björn,

On Sat, Apr 21, 2007 at 01:29:41PM +0200, Björn Steinbrink wrote:
> Hi,
> 
> On 2007.04.21 13:07:48 +0200, Willy Tarreau wrote:
> > > another thing i noticed: when using a -y larger then 1, then the window 
> > > title (at least on Metacity) overlaps and thus the ocbench tasks have 
> > > different X overhead and get scheduled a bit assymetrically as well. Is 
> > > there any way to start them up title-less perhaps?
> > 
> > It has annoyed me a bit too, but I'm no X developer at all, so I don't
> > know at all if it's possible nor how to do this. I know that my window
> > manager even adds title bars to xeyes, so I'm not sure we can do this.
> > 
> > Right now, I've added a "-B <border size>" argument so that you can
> > skip the size of your title bar. It's dirty but it's not my main job :-)
> 
> Here's a small patch that makes the windows unmanaged, which also causes
> ocbench to start up quite a bit faster on my box with larger number of
> windows, so it probably avoids some window manager overhead, which is a
> nice side-effect.

Excellent ! I've just merged it but conditionned it to a "-u" argument
so that we can keep previous behaviour (moving the windows is useful
especially when there are few of them).

So the new version 0.5 is available there :

  http://linux.1wt.eu/sched/

I believe it's the last one for today as I'm late on some work.

Thanks !
Willy

