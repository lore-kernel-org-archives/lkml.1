Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYGJQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYGJQwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYGJQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:52:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYGJQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:52:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cVpiVUOW+337ZCvsk3Hw2PMdfdMvUvgcEdaQ9ZBjceNIgB5gRHWOGG7NqUrgmH6kj
	WvBloAwHAiEmv3GG9QM6Q==
Message-ID: <6599ad830807100951w53c54f0cl50bddb4286bc696e@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:51:52 -0700
From: "Paul Menage" <menage@google.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Rik Van Riel" <riel@redhat.com>
In-Reply-To: <20080710143018.GC3782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080703155446.GB9275@redhat.com>
	 <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
	 <20080710143018.GC3782@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Well, that would mean first wrappers need to be created around all the
> applications which needs to be controlled. Then wrapper needs to
> synchronize with the classification daemon

I was suggesting that you wouldn't need a classification daemon in
this case. The logic of which cgroup to enter would be in the
script/command invoked by the wrapper.

>> - grid jobs, which are moved into the appropriate cgroup (actually,
>> currently cpuset) by the grid daemon when it starts the job
>
> So grid daemon probably first forks off, determines the right cpuset
> move the job there and then do exec?

Pretty much, yes. Most jobs have their own cpuset that's created for
them dynamically when the job starts on the machine.

Paul
