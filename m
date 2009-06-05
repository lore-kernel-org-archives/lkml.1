Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZFEKC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZFEKC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZFEKCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:02:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZFEKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:02:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TI5YMUA9+Dc97u9ThkA3+apu8nWMLPK+GV8BZdpPyLvhdlcuOEUCSBpxNk+eRXFK8
	tf3kSFV3MhvGNzZc8iMDQ==
MIME-Version: 1.0
In-Reply-To: <20090605095527.GM11755@balbir.in.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605093625.GI11755@balbir.in.ibm.com>
	 <6599ad830906050248m2c569e5bx44fb3bbddf46f8b1@mail.gmail.com>
	 <20090605095527.GM11755@balbir.in.ibm.com>
Date: Fri, 5 Jun 2009 03:02:46 -0700
Message-ID: <6599ad830906050302v70c54e7cu89a52d57f9fe72e6@mail.gmail.com>
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
>
> What about applications running as root, that can create their own
> groups? How about multiple instances of the same application started?
> Do applications need to know that creating a group will hurt
> guarantees provided to others?

Yes, of course. If you're handing out guarantees, but other users
can/will create cgroups with whatever parameters they like and won't
respect the guarantees that you've made, then those guarantees are
worthless. How do hard limits help in that situation?

Paul
