Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYD2OIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYD2OIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYD2OIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:08:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYD2OId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:08:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NKMlKncs8MU7Ethk0OsZohHGINgsBUqhyoAfRtQHwHmQ9SWmmEreRfnTkMPvrxdjs
	QoT8KCAHl1hModkwQUZ5Q==
Message-ID: <d43160c70804290708t51bdc100j9cc42a8da512aee7@mail.gmail.com>
Date: Tue, 29 Apr 2008 10:08:18 -0400
From: "Ross Biro" <rossb@google.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804291447040.5058@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
	 <Pine.LNX.4.64.0804291447040.5058@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 9:57 AM, Hugh Dickins <hugh@veritas.com> wrote:
>  Do you have CONFIG_CGROUP_MEM_RES_CTLR=y in 2.6.25?
>  That added about 20% to my lmbench "Page Fault" tests (with
>  adverse effect on several others e.g. the fork, exec, sh group).

I don't have config cgroups set.  I do have fake numa on, but I'm
pretty sure it was on for 2.6.23 as well.

# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
C

    Ross
