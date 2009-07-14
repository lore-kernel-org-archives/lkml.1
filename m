Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZGNImW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZGNImW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZGNImV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:42:21 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:19277 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZGNImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:42:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Raistlin <raistlin@linux.it>
Cc: Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <1247501182.8107.572.camel@Palantir>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <1247478955.8107.24.camel@Palantir>
	 <1247480080.7529.66.camel@twins>  <1247501182.8107.572.camel@Palantir>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 10:42:15 +0200
Message-Id: <1247560935.7500.48.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 18:06 +0200, Raistlin wrote:
> Anyway, maybe if, on some architecture, for some kind of application,
> the affinity may have been set to preserve some kind actual cache or
> memory locality for the task access pattern, maybe this could be an
> issue, couldn't it? :-)
> I mean, in some case where being sure of having a task running on a
> particular CPU is somehow of paramount importance...

Right, and you answered your own question :-), its _running_ that is
important, so as long as its blocked (not running), you're free to place
the task on another cpu if that helps out with something.



