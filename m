Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZI3OVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZI3OVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZI3OVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:21:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:34770 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZI3OVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:21:15 -0400
X-Greylist: delayed 2678 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 10:21:14 EDT
Message-ID: <4AC35EDD.1080902@openvz.org>
Date: Wed, 30 Sep 2009 17:36:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
References: <20090930124919.GA19951@in.ibm.com>
In-Reply-To: <20090930124919.GA19951@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> Hi,
> 
> Here is the v2 post of hard limits feature for CFS group scheduler. This
> RFC post mainly adds runtime borrowing feature and has a new locking scheme
> to protect CFS runtime related fields.
> 
> It would be nice to have some comments on this set!

I have a question I'd like to ask before diving into the code.
Consider I'm a user, that has a 4CPUs box 2GHz each and I'd like
to create a container with 2CPUs 1GHz each. Can I achieve this
after your patches?
