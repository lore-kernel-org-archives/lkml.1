Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZKDRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZKDRTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZKDRTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:19:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41165 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbZKDRTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:19:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oUXdSrzcX/9xMCQ6V7FI+ALiM70e1ju3Lutz+plhtKKjH0ghIJLVteavkGFEYlfT2
	4PL3GMV5emFl7Yk8AmXlg==
MIME-Version: 1.0
In-Reply-To: <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
	 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 4 Nov 2009 09:19:18 -0800
Message-ID: <6599ad830911040919k644a67cds713be3a0ea74e5d1@mail.gmail.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, libcg-devel <libcg-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       Jan Safranek <jsafrane@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 10:40 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Then, to say my own not-seriously-considered idea, I vote for
>  - /cgroup/[HierarchyName]/
> rather than /dev/ or /sys or /opt. This sounds straightforward.

We're using /dev/cgroup (for single mounts) or
/dev/cgroup/$hierarchy_name (for multiple-mount configurations) but
that's mostly just due to the historical accident of /dev/cpuset. So
/cgroup/$hierarchy_name sounds plausible, or /kernel/cgroup/... as
suggested in another email.

Paul
