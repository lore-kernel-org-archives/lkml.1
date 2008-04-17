Return-Path: <linux-kernel-owner+w=401wt.eu-S1764809AbYDQTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764809AbYDQTKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYDQTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:10:24 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:45029 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYDQTKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:10:23 -0400
Message-ID: <48079FDD.10902@linux.vnet.ibm.com>
Date: Fri, 18 Apr 2008 00:37:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com> <20080415195950.GA113@tv-sign.ru>  <4806C633.3000302@linux.vnet.ibm.com> <20080417113000.GB103@tv-sign.ru> <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com> <20080417161936.GB4482@tv-sign.ru>  <48078B9B.9070508@linux.vnet.ibm.com> <6599ad830804171050u412b5a56o8e93b21008ad17c4@mail.gmail.com>
In-Reply-To: <6599ad830804171050u412b5a56o8e93b21008ad17c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Apr 17, 2008 at 10:40 AM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
>>  >
>>  > Please look at copy_process, CLONE_THREAD requires CLONE_SIGHAND,
>>  > CLONE_SIGHAND needs CLONE_VM.
>>  >
>>
>>  What about the other way round, CLONE_VM without CLONE_THREAD?
>>
> 
> That's just a standard LinuxThreads clone() call. The patch handles
> that just fine.
> 
> Paul

Paul, it does. I was just telling Oleg about why we need the loop.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
