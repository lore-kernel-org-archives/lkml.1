Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZI3OiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZI3OiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZI3OiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:38:21 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:38376 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbZI3OiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:38:21 -0400
Date: Wed, 30 Sep 2009 20:08:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20090930143820.GG3071@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com>
 <4AC35EDD.1080902@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4AC35EDD.1080902@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Emelyanov <xemul@openvz.org> [2009-09-30 17:36:29]:

> Bharata B Rao wrote:
> > Hi,
> > 
> > Here is the v2 post of hard limits feature for CFS group scheduler. This
> > RFC post mainly adds runtime borrowing feature and has a new locking scheme
> > to protect CFS runtime related fields.
> > 
> > It would be nice to have some comments on this set!
> 
> I have a question I'd like to ask before diving into the code.
> Consider I'm a user, that has a 4CPUs box 2GHz each and I'd like
> to create a container with 2CPUs 1GHz each. Can I achieve this
> after your patches?

I don't think the GHz makes any sense, consider CPUs with frequency
scaling. If I can scale from 1.6GHz to say 2.6GHz or 2GHz to 4GHz,
what does it mean for hard limit control? Hard limits define control
over existing bandwidth, anything else would be superficial and hard
hard to get right for both developers and users.

-- 
	Balbir
