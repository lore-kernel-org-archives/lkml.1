Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZGJX6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZGJX6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbZGJX63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:58:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbZGJX62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:58:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Bbl1SMO6Y3lvcSiOD7RU42kHGqaWtyJS93UYCoPtZvU70JK4Sr/O7CsqPTZZA7rl/
	a3rfrS47t0ROvujeJDyfA==
MIME-Version: 1.0
In-Reply-To: <20090705063850.GX11273@balbir.in.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090705063850.GX11273@balbir.in.ibm.com>
Date: Fri, 10 Jul 2009 16:58:23 -0700
Message-ID: <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: lizf@cn.fujitzu.com, serue@us.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 4, 2009 at 11:38 PM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
>
> Paul, I don't see an interface to migrate all procs or at-least I
> can't read it in the changelog. As discussed in the containers
> mini-summit in 2008, it would be a nice thing to have (I've not looked
> at the implementation yet).
>

We're still working on that bit.

We want to provide the guarantee that if you write a tgid to the procs
file, all its threads get migrated even if you race with a clone()
call, and are trying to figure out a nice way to do that without
introducing unnecessary overhead/synchronization in the fork path.

Paul
