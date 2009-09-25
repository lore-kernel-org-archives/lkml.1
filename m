Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZIYD2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZIYD2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZIYD2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:28:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45765 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZIYD2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:28:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4ABC38A3.9060107@jp.fujitsu.com>
Date: Fri, 25 Sep 2009 12:27:31 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: sat <takeuchi_satoru@jp.fujitsu.com>
CC: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Raistlin <raistlin@linux.it>
Subject: Re: massive_intr on CFS, BFS, and EDF
References: <4ABC068A.6070704@jp.fujitsu.com>
In-Reply-To: <4ABC068A.6070704@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raistlin,

sat さんは書きました:
>   NOTE:
....
>   - EDF kernel shows some strange behavior as follows:
> 
>      * aptitude(debian package management tool) stacks on the way
>      * oocalc doesn't start

In addition, aptitude and oocalc are not SCHED_EDF, but SCHED_OTHER
(SCHED_FAIR). So you probably broke some codes other than sched_edf
part.

Thanks,
Satoru


