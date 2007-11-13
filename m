Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXKMGFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXKMGFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 01:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXKMGFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 01:05:34 -0500
Received: from smtp-out.google.com ([216.239.33.17]:9014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXKMGFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 01:05:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=yWXSedWV1S8YIvpoFVZDy8WUzSOug1Yd9M8OsJA54R5KGdGoHUKQZ8pN0nOB9mHWY
	Rx2iJEeD57v8vvwyVGzSA==
Message-ID: <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
Date: Mon, 12 Nov 2007 22:05:24 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
In-Reply-To: <20071113060038.GC3359@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
	 <20071113060038.GC3359@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 12, 2007 10:00 PM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>         On second thoughts, this may be a usefull controller of its own.
> Say I just want to "monitor" usage (for accounting purpose) of a group of
> tasks, but don't want to control their cpu consumption, then cpuacct
> controller would come in handy.
>

That's plausible, but having two separate ways of tracking and
reporting the CPU usage of a cgroup seems wrong.

How bad would it be in your suggested case if you just give each
cgroup the same weight? So there would be fair scheduling between
cgroups, which seems as reasonable as any other choice in the event
that the CPU is contended.

Paul
