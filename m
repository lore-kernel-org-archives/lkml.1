Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbYAFNAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbYAFNAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYAFM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:59:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbYAFM75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:59:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Date: Sun, 6 Jan 2008 13:57:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200801052042.56042.rjw@sisk.pl> <20080106094504.GE26291@elte.hu>
In-Reply-To: <20080106094504.GE26291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061357.36324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Subject		: soft lockup - CPU#1 stuck for 15s! [swapper:0]
> > Submitter	: "Parag Warudkar" <parag.warudkar@gmail.com>
> > Date		: 2007-12-07 18:14
> > References	: http://lkml.org/lkml/2007/12/7/299
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9525
> > Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
> > 		  Thomas Gleixner <tglx@linutronix.de>
> > 		  Ingo Molnar <mingo@elte.hu>
> 
> i think this only occurs with cpuidle, right? drivers/cpuidle/ and 
> CPU_IDLE is new in 2.6.24 so this appears to be a bug in that code (or a 
> bug elsewhere triggered by that code), not a regression from v2.6.23.

OK, removed from the regressions list.

Thanks,
Rafael
