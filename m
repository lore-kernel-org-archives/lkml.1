Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbXDDUKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbXDDUKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXDDUKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:10:01 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:40906 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbXDDUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:09:58 -0400
From: dasperry@comcast.net (dave_sperry@ieee.org)
To: Ingo Molnar <mingo@elte.hu>
Cc: David Sperry <dave_sperry@ieee.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Improved UDP performance using 2.6.21-rc5-rt10
Date: Wed, 04 Apr 2007 20:09:57 +0000
Message-Id: <040420072009.13410.4614061500006C50000034622206424613979D9D0A9F9C0E0B@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct  4 2006)
X-Authenticated-Sender: ZGFzcGVycnlAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Here are some more results:

Nvidia w/cyclesoak
 2.6.21-rc5-rt10           938          32%
    netperf @51
    hardirq @50
    softirq @50

Nvidia w/top
 2.6.21-rc5-rt12           938          31%
    netperf @51
    hardirq @50
    softirq @50

Hopefully I'll run some more tests in the morning

Thanks,
Dave
 -------------- Original message ----------------------
From: Ingo Molnar <mingo@elte.hu>
> 
> * dave_sperry@ieee.org <dasperry@comcast.net> wrote:
> 
> > rt10 shows a big improvement over rt8
> > 
> > ##################################################
> > etup                    Thruput      CPU% 
> > Nvidia
> > 2.6.21-rc5-rt8           938          65%
> >    netperf @51
> >    hardirq @50
> >    softirq @50
> > 
> > Nvidia
> > 2.6.21-rc5-rt10           938          32%
> >    netperf @51
> >    hardirq @50
> >    softirq @50
> 
> cool! Btw., could you run the same but without running cyclesoak, and 
> only watching the 'idle' metric in 'top' or vmstat? I found in my 
> experiments that cyclesoak sometimes interfers with the workload - and 
> the idle stats are precise and accurate on -rt. (they are not on 
> vanilla)
> 
> 	Ingo

