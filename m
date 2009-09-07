Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZIGA0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZIGA0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 20:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbZIGA0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 20:26:15 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:35645 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZIGA0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 20:26:14 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC484@exchange.ZeugmaSystems.local>
Date: Sun, 6 Sep 2009 17:26:13 -0700
Cc: Fabio Checconi <fchecconi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, Dario Faggioli <raistlin@linux.it>,
       Anirban Sinha <ASinha@zeugmasystems.com>
Content-Transfer-Encoding: 7bit
Message-Id: <93AD5C37-E118-4E5C-8684-EBA548A43492@anirban.org>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local> <20090905204037.GE4953@gandalf.sssup.it> <DDFD17CC94A9BD49A82147DDF7D545C54DC481@exchange.ZeugmaSystems.local> <D0B95E79-EDEC-487A-B8AB-0D90E4E81A9E@anirban.org> <20090906132104.GK14492@gandalf.sssup.it> <DDFD17CC94A9BD49A82147DDF7D545C54DC484@exchange.ZeugmaSystems.local>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 > Running your program I'm unable to reproduce the same issue on a  
recent
 > kernel here; for 25ms over 100ms across several runs I get less  
than 2%.
 > This number increases, reaching your values, only when using short
 > periods (where the meaning for short depends on your HZ value),


In our kernel, the jiffies are configured as 100 HZ.

 > which
 > is something to be expected, due to the fact that rt throttling uses
 > the tick to charge runtimes to tasks.

Hmm. I see. I understand that.


 > Looking at the git history, there have been several bugfixes to the  
rt
 > bandwidth code from 2.6.26, one of them seems to be strictly  
related to
 > runtime accounting with your setup:

I will apply these patches on Tuesday and rerun the tests.


