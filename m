Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbZAUERF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbZAUERF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZAUEQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:16:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40063 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbZAUEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:16:49 -0500
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
       roland@redhat.com, bastian@waldi.eu.org, daniel@hozac.com,
       xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
References: <20090117202638.GA11825@us.ibm.com>
	<20090119110906.58ccbcbd.kamezawa.hiroyu@jp.fujitsu.com>
	<20090121030500.GA32138@us.ibm.com>
	<20090121125300.b5916256.kamezawa.hiroyu@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 20 Jan 2009 20:16:40 -0800
In-Reply-To: <20090121125300.b5916256.kamezawa.hiroyu@jp.fujitsu.com> (KAMEZAWA Hiroyuki's message of "Wed\, 21 Jan 2009 12\:53\:00 +0900")
Message-ID: <m1k58pwaxj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0016]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> What makes me confused is "Container". There is no "Container" in
> the linux kernel, just cgroup and its subsyss.
> (Some source codes still use "cont" but new codes all use "cgroup" or "cgrp" )
>
> So, I asked whether "Container" means "Namespace subsys" or something different.

"Container" is what we use to refer to the user space concept, that is built
from a set of namespaces and control groups.  A Container that looks like
a standard linux install from the inside is what we expect the most common
use of namespaces and control groups to be.

Eric
