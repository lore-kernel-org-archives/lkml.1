Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYB1KG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYB1KG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbYB1KGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:06:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757256AbYB1KGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:06:03 -0500
Date: Thu, 28 Feb 2008 02:04:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sourceware.org,
       prasadav@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH 0/3] A kernel tracing interface
Message-Id: <20080228020437.8f99f646.akpm@linux-foundation.org>
In-Reply-To: <1204065517.26964.14.camel@lc4eb748232119.ibm.com>
References: <1204065517.26964.14.camel@lc4eb748232119.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 14:38:37 -0800 "David J. Wilder" <dwilder@us.ibm.com> wrote:

> These patches provide a kernel tracing interface called "trace".
> 
> ChangeLog:
> -Updated to 2.6.25-rc2-mm1
> -Removed sem_watch example, to hard to maintain.
> -Added a new example that demonstrates per-cpu continuous tracing
>  of data generated using marker probes.
> -Removed inline from relay patch.
> -Moved examples into /sample directory.
> 
> The motivation for "trace" is to:
> - Provide a simple set of tracing primitives that will utilize the high-
>   performance and low-overhead of relayfs for passing traces data from
>   kernel to user space.
> - Provide a common user interface for managing kernel traces.
> - Allow for binary as well as ascii trace data.
> - Incorporate features from the systemtap runtime that are
>   useful to others.

So... what's the story on this versus lttng?

Is there some userspace code available for people to test this?  Maybe it's
mentioned and I missed it.

It'd be interesting to see a writeup of the proposed kernel<->userspace
interfaces.  I see a description of kernel-internal interfaces, but how do
users use it?

I see it uses things from blktrace.  Can blktrace be switched over to being
a client of this code?

