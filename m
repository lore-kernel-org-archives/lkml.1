Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbXJCSQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbXJCSQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXJCSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:16:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbXJCSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:16:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YfjS+oyP6aDOv+8lZInZtu0jayWsujjwpILywB1o8wOTllcx/YFxVGxoQn4EQLsXC
	MdN/EeB79WXgi2WlPcyRA==
Message-ID: <6599ad830710031115g3a45e996j30bd7b5e8d77a035@mail.gmail.com>
Date: Wed, 3 Oct 2007 11:15:57 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 03/33] task containersv11 add tasks file interface
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071003105157.254c51a4.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070917210307.116234000@menage.corp.google.com>
	 <20070917210426.579524000@menage.corp.google.com>
	 <20071003010923.c606c176.pj@sgi.com>
	 <6599ad830710030816m32321b54gbc79c24d0a39941b@mail.gmail.com>
	 <20071003105157.254c51a4.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Paul Jackson <pj@sgi.com> wrote:
>
> So after changing the 'cpus' of a cpuset, you (something in
> user space) then has to rewrite every pid in that cpusets
> tasks file back to that same tasks file, in order to get the
> change to be applied to each of those tasks, and get them to
> start running on their new CPUs.

What happens to the new child that got forked right between userspace
reading the 'tasks' file and writing back the pids?

Paul
