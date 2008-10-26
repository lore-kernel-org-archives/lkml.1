Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYJZNtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYJZNtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYJZNt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:49:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47571 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYJZNtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:49:25 -0400
Date: Sun, 26 Oct 2008 09:49:05 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
Message-ID: <20081026134904.GG8210@redhat.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com> <1223817124-27239-3-git-send-email-edwintorok@gmail.com> <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com> <y0mbpx71oqp.fsf@ton.toronto.redhat.com> <1225027782.32713.10.camel@twins> <490472E5.2070207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490472E5.2070207@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sun, Oct 26, 2008 at 03:38:45PM +0200, Török Edwin wrote:

> [...]  In userspace I can get a stacktrace using DWARF unwind info,
> but doing that in the kernel would be too expensive, right? [...]

We're experimenting with just that in systemtap.  The expenses
(memory: megabytes of unwind data, time: running code to process it)
would be paid only for the duration of a systemtap script that needs
that particular sort of information.

- FChE
