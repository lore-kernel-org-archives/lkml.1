Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYB1MPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYB1MPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYB1MPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:15:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33787 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYB1MPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:15:08 -0500
Date: Thu, 28 Feb 2008 21:13:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <srostedt@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20080228115041.GA22082@elte.hu>
References: <20080228192509.BDCF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080228115041.GA22082@elte.hu>
Message-Id: <20080228211044.BDD5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> thanks for bisecting it down! Could ia64 have trouble accessing the 
> percpu data structures of the scheduler?
> 
> does the patch below resolve the hang?

Thanks!
that patch works well on my test environment.

Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


BTW: Your work is ultimate fast. it's wonderful :)




