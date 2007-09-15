Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXIOAu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXIOAu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXIOAuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:50:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbXIOAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:50:19 -0400
Date: Fri, 14 Sep 2007 17:49:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 0/2] A kernel tracing interface
Message-Id: <20070914174953.04b0b158.akpm@linux-foundation.org>
In-Reply-To: <46E9CB0D.2040206@us.ibm.com>
References: <46E9CB0D.2040206@us.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 16:43:09 -0700
David Wilder <dwilder@us.ibm.com> wrote:

> These patches provide a kernel tracing interface called "trace".
> 
> The motivation for "trace" is to:
> - Provide a simple set of tracing primitives that will utilize the high-
>   performance and low-overhead of relayfs for passing traces data from
>   kernel to user space.
> - Provide a common user interface for managing kernel traces.
> - Allow for binary as well as ascii trace data.
> - Incorporate features from the systemtap runtime that are
>   useful to others.
> 
> History- Versions of this code have been submitted for review under
> a couple of different names.  The original submission was called UTT,
> it was later re-submitted as GTSC.   Christoph Hellwig commented "The
> code looks fine ...but the name is just dumb".  Following Christoph's
> advice, I changed the name to simply "Trace".
> 
> This patch addresses review comments made by Christoph Hellwig and Mathieu
> Desnoyers.  Changes include the addition of a mutex and synchronization
> protecting trace state changes (using RCU) and the reduction of the
> number of exports.
> 
> Patches are against 2.6.23-rc4-mm1
> 
> Required patches:
> 1/2 Trace code and documentation
> 2/2 Relay reset consumed  (required for trace's "rewind" feature")
> 
> Signed-off-by: David Wilder <dwilder@us.ibm.com>

Well the code looks neat and easy enough to merge.

What exactly is the relationship between this and systemtap and kprobes and
all the other tracing things which people are doing?

