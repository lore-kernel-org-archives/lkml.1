Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXFIHKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXFIHKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXFIHKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:10:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbXFIHKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:10:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Ozq6WZEaEJv/rrk2xj0byxNGfKgGxN7g+gXfq/D2Ke4grWe3QpclYKKneDXvm9djW
	MTgl2JoD2TJhzABaC/2yg==
Message-ID: <6599ad830706090009q25e13ff6ybad7d7f7db21cd48@mail.gmail.com>
Date: Sat, 9 Jun 2007 00:09:55 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [0/1] [patch -mm] Add containerstats (v3)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20070608124816.fa1e70d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608181346.15764.2467.sendpatchset@balbir-laptop>
	 <20070608124816.fa1e70d8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 08 Jun 2007 23:43:46 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> > This patch implements per container statistics infrastructure and re-uses
> > code from the taskstats interface.
>
> boggle.
>
> Symbol: CONTAINERS [=y]
>   Selected by: CONTAINER_DEBUG || CPUSETS && SMP || CONTAINER_CPUACCT
>
> Paul, that's just bizarre.  How come it was done this way?

Containers on their own without any subsystems aren't hugely useful.
So the plan was that any container subsystem would "select CONTAINERS"
to cause the container framework to be built. I'm happy to change it
to invert the dependencies if you'd prefer.

Paul
