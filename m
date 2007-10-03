Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbXJCPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbXJCPv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbXJCPvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:51:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbXJCPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:51:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gM2PfA9vdyfnLiZVwmo0mxR2dTi4B+4/gUDB9bIPMpqJU9Xzk73+kjpXMN3cb0/rS
	JW6QWYq93vLgT+jcGYeMg==
Message-ID: <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
Date: Wed, 3 Oct 2007 08:51:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Cedric Le Goater" <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David Rientjes" <rientjes@google.com>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>, containers@lists.osdl.org,
       balbir@linux.vnet.ibm.com
In-Reply-To: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> The code in kernel/cgroup.c attach_task() which skips the
> attachment of a task to the group it is already in has to be
> removed.  Cpusets depends on reattaching a task to its current
> cpuset, in order to trigger updating the cpus_allowed mask in the
> task struct.

Can you explain a bit more about why this is needed? (i.e. specific
scenarios where cpusets will break without this change).

What triggers the reattach in normal use? Something from userspace?

Paul
