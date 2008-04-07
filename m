Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYDGMSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYDGMSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbYDGMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:18:14 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41917 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbYDGMSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:18:14 -0400
Message-ID: <47FA10BB.9000305@linux.vnet.ibm.com>
Date: Mon, 07 Apr 2008 17:46:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pavel Emelianov <xemul@openvz.org>,
       hugh@veritas.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Disable the memory controller by default
References: <20080407115137.24124.59692.sendpatchset@localhost.localdomain> <20080407120340.GB16647@one.firstfloor.org> <47FA0D85.201@linux.vnet.ibm.com> <2f11576a0804070516r185bff87t449c315bd7787c7e@mail.gmail.com>
In-Reply-To: <2f11576a0804070516r185bff87t449c315bd7787c7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>  The boot control options apply to all controllers and we want to allow
>>  controllers to decide whether they should be turned on or off. With sufficient
>>  documentation support in Documentation/kernel-parameters.txt, don't you think we
>>  can expect this to work as the user intended?
> 
> 2 parameter is wrong?
> 
>        cgroup_disable= [KNL] Disable a particular controller
>                        Format: {name of the controller(s) to disable}
>        cgroup_enable= [KNL] Enable a particular controller
>                        Format: {name of the controller(s) to enable}
> 

No, it is not all bad. That can be done, but we need to guard against a usage like

cgroup_disable=memory cgroup_enable=memory

The user will probably get what he/she deserves for it.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
