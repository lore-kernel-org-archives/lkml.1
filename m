Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbXGJTFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbXGJTFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXGJTFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:05:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbXGJTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:05:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ty0ftsAL+wlc6rcOGZOMj/dJdZ1DKNYZZrsO3k+GvWPoqDO2+Na7s6YugDMD+om/U
	RxJpoX3IVpc05x1QmPdoA==
Message-ID: <6599ad830707101205p405167e5t54856e6f6bb752f0@mail.gmail.com>
Date: Tue, 10 Jul 2007 12:05:14 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <20070710115319.0bdaff34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710105240.GA20914@linux.vnet.ibm.com>
	 <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	 <20070710115319.0bdaff34.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Andrew, how about we merge enough of the container framework to
> > support CFS? Bits we could leave out for now include container_clone()
> > support and the nsproxy subsystem, fork/exit callback hooks, and
> > possibly leave cpusets alone for now (which would also mean we could
> > skip the automatic release-agent stuff). I'm in Tokyo for the Linux
> > Foundation Japan symposium right now, but I should be able to get the
> > new patchset to you for Friday afternoon.
>
> mm..  Given that you propose leaving bits out for the 2.6.23 merge, and
> that changes are still pending and that nothing will _use_ the framework in
> 2.6.23

That's what I was originally thinking too, but since CFS has been
merged, CFS group scheduling would use it.

Paul
