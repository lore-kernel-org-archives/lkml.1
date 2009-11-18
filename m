Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZKRWiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZKRWiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZKRWiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:38:13 -0500
Received: from mail.bluehost.com ([74.220.195.75]:43541 "HELO
	mail.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752049AbZKRWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:38:12 -0500
Message-ID: <4B04775A.4040100@bluehost.com>
Date: Wed, 18 Nov 2009 15:38:18 -0700
From: Spencer Candland <spencer@bluehost.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
References: <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com> <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> Could you please test this patch, if it solve all utime decrease
> problems for you:
> 
> http://patchwork.kernel.org/patch/59795/

Yes, this seems to solve the problem.

- Spencer
