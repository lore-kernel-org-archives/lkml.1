Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYEGA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYEGA0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYEGA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:26:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYEGA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:26:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fslD5kDjWGvOWUeqYz4H7Pzscf2VNWVZ5MoFFmTy12/HRpog8Nf1KXBjw/x2FuHbG
	w9MwbqybGqMBJPA71eUUA==
Message-ID: <6599ad830805061726n33f69552k756e8754387e4b8c@mail.gmail.com>
Date: Tue, 6 May 2008 17:26:22 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the bulk cgroup_add_files() API
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       lizf@cn.fujitsu.com, "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Hiroyuki KAMEZAWA" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Dimitri Sivanich" <sivanich@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080506192018.26c1e3b7.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	 <6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	 <20080429053804.6d083a7f.akpm@linux-foundation.org>
	 <20080506192018.26c1e3b7.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 5:20 PM, Paul Jackson <pj@sgi.com> wrote:
>
>  I definitely agree with the above observations of Paul M.  I suspect
>  that the patch might be missing the lines needed to -remove- the
>  FILE_SCHED_RELAX_DOMAIN_LEVEL cases from the old style
>  cpuset_common_file_read and cpuset_common_file_write switches.

Yes, it is - but I didn't have a tree with the relevant bits in it to
remove, as far as I could see.

>
>   2) I didn't see any replies from Paul M in response to
>     Andrews above request to "send us any needed fixup later
>     in the week".
>
>         ==> Paul M or akpm - Is this fixup in the pipeline?

Not yet - I was waiting for 2.6.26-rc1-mm1 to come out. But I can send
one against 2.6.26-rc1 directly if that helps.

Paul
