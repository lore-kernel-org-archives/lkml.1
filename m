Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbXFDUbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbXFDUbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXFDUa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:30:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49618 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXFDUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:30:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=e03skNQs09sTsuaaxaYH3qTFBb+kDgkHuQn9BVkIQuIqDqSOmBx2O/6QLT2YEVOLR
	VwmnFwwAYYEh7wRHreTNA==
Message-ID: <6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
Date: Mon, 4 Jun 2007 13:30:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
In-Reply-To: <20070604123151.4db007a6.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529130104.461765000@menage.corp.google.com>
	 <20070604191412.GA901@sergelap.austin.ibm.com>
	 <20070604123151.4db007a6.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Paul Jackson <pj@sgi.com> wrote:
>
> Yup - early in the life of cpusets, a created cpuset inherited the cpus
> and mems of its parent.  But that broke the exclusive property big
> time.  You will recall that a cpu_exclusive or mem_exclusive cpuset
> cannot overlap the cpus or memory, respectively, of any of its sibling
> cpusets.
>

Maybe we could make it a per-cpuset option whether children should
inherit mems/cpus or not?

Paul
