Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZFEKDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZFEKDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFEKDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:03:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5468 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZFEKDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:03:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=khWzlXpKkxmzpJhCgwxIQ18Qnk4YJgiv9jg2on979Stju5T5aJU7T1ZxB0WA/jAYZ
	nOvJjlp4iBkRpl3knnAJw==
MIME-Version: 1.0
In-Reply-To: <20090605095931.GE4601@linux.vnet.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605092733.GA27486@in.ibm.com>
	 <6599ad830906050232n11aa30d8xfcda0a279a482f32@mail.gmail.com>
	 <20090605094811.GD4601@linux.vnet.ibm.com>
	 <6599ad830906050251h18f4e037h182f61aa80a5b046@mail.gmail.com>
	 <20090605095931.GE4601@linux.vnet.ibm.com>
Date: Fri, 5 Jun 2009 03:03:18 -0700
Message-ID: <6599ad830906050303r404c325anc60ded4f45a50b95@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Paul Menage <menage@google.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
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

On Fri, Jun 5, 2009 at 2:59 AM, Dhaval Giani<dhaval@linux.vnet.ibm.com> wrote:
>
> I think we are focusing on the wrong use case here. Guarantees is just a
> useful side-effect we get by using hard limits. I think the more
> important use case is where the provider wants to limit the amount of
> time a user gets (such as in a cloud).
>
> Maybe we should direct our attention in solving that problem? :)
>

Yes, that case and the "predictable load test behaviour" case are both
good reasons for hard limits.

Paul
