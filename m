Return-Path: <linux-kernel-owner+w=401wt.eu-S966031AbXDCR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966031AbXDCR3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966044AbXDCR3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:29:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966031AbXDCR3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:29:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uhfbIF/plJNoE4rIUewQHCwU2m6OlgbsXTksmhj4bIJMZChYdbn1ic+xlE/LKYi3A
	JMXHD42QraxrTyv/o+yuQ==
Message-ID: <6599ad830704031029x7931e698pbab3c4f22a46a21d@mail.gmail.com>
Date: Tue, 3 Apr 2007 10:29:01 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
In-Reply-To: <20070403173400.GM2456@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070331024722.GA808@in.ibm.com>
	 <20070402142727.GF2456@in.ibm.com>
	 <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
	 <20070403153220.GA24946@sergelap.austin.ibm.com>
	 <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
	 <20070403164615.GJ2456@in.ibm.com>
	 <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
	 <20070403171155.GK2456@in.ibm.com>
	 <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
	 <20070403173400.GM2456@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Tue, Apr 03, 2007 at 10:10:35AM -0700, Paul Menage wrote:
> > Agreed. So I'm not saying it's fundamentally a bad idea - just that
> > merging container_group and nsproxy is a fairly simple space
> > optimization that could easily be done later.
>
> IMHO, if we agree that space optimization is important, then its better
> we tackle it right at design phase, rather than ripping it out later ..
>

"Premature optimization is the root of all evil".

I think we're in agreement that there's value in having an aggregator
to avoid every task having to have a forest of pointers. But it
wouldn't be a major design change to switch that aggregator from being
container_group to being nsproxy at some later point.

Paul
