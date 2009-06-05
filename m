Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZFEJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZFEJ6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZFEJ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:57:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZFEJ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:57:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TMaMgQuMO+pli7ZmSkehj0altdTcX3ey6lCfy+z6BWj2GtnDJmPvAtPiferUmS3Kf
	PpWuaM+6YugkatYGyi+AQ==
MIME-Version: 1.0
In-Reply-To: <20090605095527.GM11755@balbir.in.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605093625.GI11755@balbir.in.ibm.com>
	 <6599ad830906050248m2c569e5bx44fb3bbddf46f8b1@mail.gmail.com>
	 <20090605095527.GM11755@balbir.in.ibm.com>
Date: Fri, 5 Jun 2009 02:57:50 -0700
Message-ID: <6599ad830906050257q60e124dbt20dea7c6065f1edc@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 2:55 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
> The point is that there is no single control entity for creating
> groups. if run a solution, it might create groups without telling the
> user. No one is arbitrating, not even libcgroup. What if someone
> changes the cpuset assignment and moves CPUS x to y in an exclusive
> cpuset all of a sudden. How do we arbitrate?

But in that situation, how do hard limits help? If you can't control
when cgroups are being created, and you can't control their shares,
how are you going to control their hard limits?

Paul
