Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbYA0Mjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYA0Mjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYA0Mfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54882 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbYA0Mfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:35:39 -0500
Date: Sun, 27 Jan 2008 13:35:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
Message-ID: <20080127123514.GA21282@elte.hu>
References: <479BCE03.6070603@gmail.com> <479BD1D1.8020503@gmail.com> <20080127062703.GA23444@elte.hu> <20080127083129.c14452ca.kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127083129.c14452ca.kjwinchester@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> although it is not complete.  For some reason (xubuntu, probably) dash 
> is my default shell and it does not like the for loop at line 69 of 
> that script:
> 
> for ((i=0; i<5; i++)); do
>  echo "-- sched_debug #$i: --"       >> $FILE
>  date                                >> $FILE
>  cat /proc/sched_debug               >> $FILE 2>/dev/null
>  sleep 1
> done
> 
> Not being a shell scripter, I have no idea how to port that to dash.

oops, stick this to the top of the script:

  #!/bin/bash

as that loop is a bashism. (I've updated the script on my site as well.)

	Ingo
