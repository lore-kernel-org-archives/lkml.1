Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZJAFN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZJAFN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 01:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZJAFN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 01:13:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53808 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbZJAFN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 01:13:56 -0400
Date: Thu, 1 Oct 2009 10:42:30 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20091001051230.GA3451@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930143820.GG3071@balbir.in.ibm.com> <4AC374E3.9000308@openvz.org> <20090930153053.GM3071@balbir.in.ibm.com> <20090930223039.GO484@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930223039.GO484@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 12:30:39AM +0200, Herbert Poetzl wrote:
> 
> Linux-VServer uses interval and rate, which is very similar
> to your setup, except that we use two pairs to achive
> a differentiation for 'busy' and 'idle' cases, i.e. when
> the cpu(s) would go idle, we switch from R1/I1 to R2/I2
> for all guests, allowing to distribute the excess differently
> than the 'active' part ... but only one set is needed for
> hard limits ...

Do you have examples of how you choose R1, I1 and R2, I2 for guests
running typical workloads ?

Regards,
Bharata.
