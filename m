Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbXFIIIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbXFIIIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbXFIIIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:08:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47631 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760629AbXFIIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:08:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FdJJcY0ZPtw8jB2Z1GcJlGOsYmoc5uLeMdry0kNm4AWh8hTmUFKJ7BddimOUwbOq0
	zfBrsJR8yS/cW59sDjwow==
Message-ID: <6599ad830706090107u63b7e8c2p8e5c65778cde7473@mail.gmail.com>
Date: Sat, 9 Jun 2007 01:07:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [0/1] [patch -mm] Add containerstats (v3)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20070609010202.4c2b51fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608181346.15764.2467.sendpatchset@balbir-laptop>
	 <20070608124816.fa1e70d8.akpm@linux-foundation.org>
	 <6599ad830706090009q25e13ff6ybad7d7f7db21cd48@mail.gmail.com>
	 <20070609010202.4c2b51fb.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - CONTAINER_DEBUG should depend on CONTAINERS

CONTAINER_DEBUG is actually a container subsystem whose sole purpose
is to provide debugging information about any hierarchy that it's
mounted as a part of. So in some senses it's in the same boat as
something like cpusets or the RSS controller. CONFIG_CONTAINER_DEBUG
doesn't affect any of the container framework code.

>
> - the CPUSETS && SMP is weird and should be deleted, unless I'm missing
>   something

Cpusets depends on SMP in the vanilla tree, so that's not anything new
that I added.

>
> - CONTAINERS should depend on CPUSETS

You mean the other way around?

>
> - That leaves CONTAINER_CPUACCT.

Really, CONTAINER_CPUACCT should have the same relationship to
CONTAINERS as CPUSETS does.

Paul
