Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZKDVZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZKDVZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbZKDVZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:25:48 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7771 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbZKDVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:25:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=u3DAjfEhq06+iHwxUKa/oEiEKv2C5NNuKa4cI++kMKnSlruPggjTDkiBzxuDwNgzX
	zkjiKslMP7IfyMtBVR8tg==
MIME-Version: 1.0
In-Reply-To: <20091104173517.GA3668@count0.beaverton.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
	 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091104173517.GA3668@count0.beaverton.ibm.com>
Date: Wed, 4 Nov 2009 13:25:46 -0800
Message-ID: <6599ad830911041325i9b309a7y4d912d6be7ddbdd9@mail.gmail.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan@smtp1.linux-foundation.org, Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       Safranek <jsafrane@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 9:35 AM, Matt Helsley <matthltc@us.ibm.com> wrote:
>
> If anything, "standardizing" the mount point(s) will likely provide a false
> sense of uniformity and we'll get some bad userspace scripts/tools that
> break when "nonstandard" usage appears. Leaving the mount point undefined
> forces anyone writing scripts or tools to consider whether they want to be
> portable and, if so, the proper way to find the cgroup hierarchies they need
> to manipulate.

Scanning /proc/mounts to find the relevant mount locations is pretty
simple, for code that's just wanting to use existing cgroup mounts.
But for the code that sets up mounts in the first place, its probably
helpful to have recommendations of suitable locations.

Paul
