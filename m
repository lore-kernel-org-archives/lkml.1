Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZIGA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZIGA2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 20:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbZIGA2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 20:28:25 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:44051 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZIGA2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 20:28:24 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC485@exchange.ZeugmaSystems.local>
Date: Sun, 6 Sep 2009 17:28:23 -0700
Cc: Anirban Sinha <ani@anirban.org>
Content-Transfer-Encoding: 7bit
Message-Id: <FC8E625F-CF9B-4943-8D09-F7D474834A69@anirban.org>
References: <DDFD17CC94A9BD49A82147DDF7D545C54DC483@exchange.ZeugmaSystems.local> <DDFD17CC94A9BD49A82147DDF7D545C54DC485@exchange.ZeugmaSystems.local>
To: Anirban Sinha <ASinha@zeugmasystems.com>,
       Dario Faggioli <raistlin@linux.it>, a.p.zijlstra@chello.nl,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fchecconi@gmail.com>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Dunno.  Fly or die little patchlet (toss).

 > sched: allow the user to disable RT bandwidth aggregation.

Hmm. Interesting. With this change, my results are as follows:

rt_runtime/rt_period   % of reg iterations

0.2                    100%
0.25                   100%
0.3                    100%
0.4                    100%
0.5                    82%
0.6                    66%
0.7                    54%
0.8                    46%
0.9                    38.5%
0.95                   32%


This results are on a quad core blade. Does it still makes sense though?
Can anyone else run the same tests on a quadcore over the latest kernel?
I will patch our 2.6.26 kernel with upstream fixes and rerun these  
tests on tuesday.

Ani




