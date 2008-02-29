Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYB2BL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYB2BL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbYB2BDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:03:44 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763778AbYB2BDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:03:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cOrNglV7T1O0IN/m30VaTwxmZ9WdJSJulH01vA+HbNW5lJmFCp2CzPyaigOeJezAa
	26gVrEQc08Ad9kPFpuBLQ==
Message-ID: <6599ad830802281703hb3cff06r8ba4755f705a0879@mail.gmail.com>
Date: Thu, 28 Feb 2008 17:03:33 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, xemul@openvz.org,
       akpm@linux-foundation.org
In-Reply-To: <20080228173618.139f5bb4.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228173618.139f5bb4.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 3:36 PM, Paul Jackson <pj@sgi.com> wrote:
>
>  We could accomplish that much by decreeing that future new kernel
>  generated names that we might add follow some stronger convention,
>  such as the cgroup_ or appropriate subsystem prefix.

Subsystem-created files already have an appropriate prefix.

> No need to
>  change the existing well known names for this reason.

But that's part of my point - is it reasonable to describe a system
that was only introduced in 2.6.24 as "well-known"?

>
>    Actually, in terms of 'common names used
>  by humans' some of these names, "tasks" and "notify_on_release", date
>  back much earlier than that.  Please don't rename these two files in
>  cgroups; and of course absolutely don't rename them in cpusets.

No, I wasn't planning to make any changes to cpusets.

>
>  Please don't end up with different names of these files, depending on
>  whether you're in cgroups or cpusets, either.

That already happens - when mounted as the "cpuset" filesystem, we
have names like "mems_allowed". When mounted as cgroups, we have names
like cpuset.mems_allowed.

>
> > Could we do something like auto-prefixing user-created directories with a
>  > fixed string so that there is no way in which the user can cause a
>  > collision with kernel-created files?
>
>  Lordy lordy -- a bunch of intrusive, complicating crap to solve a
>  non-existent problem (sorry for the indelicate choice of words ;).

No, I don't like that idea either.

Paul
