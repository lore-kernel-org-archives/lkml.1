Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYA0XIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYA0XIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbYA0XIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:08:16 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:60296 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYA0XIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=frGwWaeTLM/roG4FNM5kj10IJ8HqhS1sbzXQQVvM5nZxnOkfwR88FpObEN4UYajXKqNA8yyrXuAn1NBsZQmx/DoK6WthNPdLPK4gftq/WI+RWc1JoBiFmj5sx7ZCnANDbInsXYGzDJ1BNd1dbSCS4IxtwkI1xFpwV3uJIa4xF0w=
Date: Sun, 27 Jan 2008 19:08:10 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
Message-Id: <20080127190810.93f4c9ee.kjwinchester@gmail.com>
In-Reply-To: <20080127123514.GA21282@elte.hu>
References: <479BCE03.6070603@gmail.com>
	<479BD1D1.8020503@gmail.com>
	<20080127062703.GA23444@elte.hu>
	<20080127083129.c14452ca.kjwinchester@gmail.com>
	<20080127123514.GA21282@elte.hu>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 13:35:14 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
> > although it is not complete.  For some reason (xubuntu, probably) dash 
> > is my default shell and it does not like the for loop at line 69 of 
> > that script:
> > 
> > for ((i=0; i<5; i++)); do
> >  echo "-- sched_debug #$i: --"       >> $FILE
> >  date                                >> $FILE
> >  cat /proc/sched_debug               >> $FILE 2>/dev/null
> >  sleep 1
> > done
> > 
> > Not being a shell scripter, I have no idea how to port that to dash.
> 
> oops, stick this to the top of the script:
> 
>   #!/bin/bash
> 
> as that loop is a bashism. (I've updated the script on my site as well.)
> 
> 	Ingo

Here is the updated script run without the missing info:


http://personal.nbnet.nb.ca/kwin/cfs-debug-info-2008.01.27-19.04.50


-- 
Kevin Winchester <kjwinchester@gmail.com>
