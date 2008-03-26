Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYCZO3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYCZO3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbYCZO27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:28:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39119 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751202AbYCZO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:28:58 -0400
Date: Wed, 26 Mar 2008 10:28:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: rpurdie@rpsys.net, <gitster@pobox.com>, <corbet@lwn.net>, <mingo@elte.hu>,
       <mb@bu3sch.de>, <linux-kernel@vger.kernel.org>, <khali@linux-fr.org>,
       <hmh@hmh.eng.br>, <geert@linux-m68k.org>, <akpm@linux-foundation.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
In-Reply-To: <20080325232042.4EDA7346532@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803261027580.4969-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, David Brownell wrote:

> I _almost_ hate bringing this lovely flamage back onto $SUBJECT ... but
> what's the resolution for the leds-gpio.c issue?  I've not seen a merge
> notice for the patch I submitted a week ago now:
> 
> 	http://marc.info/?l=linux-kernel&m=120597839009399&w=2
> 
> Just a "leaning..." comment:
> 
> 	http://marc.info/?l=linux-kernel&m=120606104619198&w=2
> 
> Seems to me that by now there ought to be resolution on at least
> one of the issues brought up on this thread.  :)

Is it reasonable to have two version of that subroutine: one meant to 
be called in a sleepable context and the other to be called when 
sleeping isn't allowed?

Alan Stern

