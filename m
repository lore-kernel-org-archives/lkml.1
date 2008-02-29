Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYB2KI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYB2KI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYB2KIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:08:52 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYB2KIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:08:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RvLAaASix7ghU/kQ6NsIEoJFQBiZsmIjPaujZG6qLHMdPr3QrVvlQHW8nWyCBGsuG
	N8HxVo9jKVb31cubm3dTA==
Message-ID: <6599ad830802290208l6b9d97d1l67e351fc2f9112f7@mail.gmail.com>
Date: Fri, 29 Feb 2008 02:08:45 -0800
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
Cc: vatsa@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
In-Reply-To: <20080229060435.GB5478@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080229043242.110741439@linux.vnet.ibm.com>
	 <20080229043751.555866685@linux.vnet.ibm.com>
	 <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
	 <20080229060435.GB5478@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 10:04 PM, Dhaval Giani
<dhaval@linux.vnet.ibm.com> wrote:
> On Thu, Feb 28, 2008 at 09:48:51PM -0800, Paul Menage wrote:
>
> > On Thu, Feb 28, 2008 at 8:32 PM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>  >
>
> > Can I suggest, in order to be more generic, that this patch instead
>  > set each CPU's counter to the written value divided by the number of
>  > CPUs? (Either forgetting the remainder, or spreading it among the
>  > first few CPUs).
>  >
>
>  This patch is only allowing a reset of the stats. In what sort of a
>  situation would one be looking for changing the usage value?

How about Checkpoint/Restart?

It seems that if you're going to the effort to notice a non-zero value
and return an error, it wouldn't be much more effort to do something
useful with that non-zero value instead.

Paul
