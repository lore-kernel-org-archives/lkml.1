Return-Path: <linux-kernel-owner+w=401wt.eu-S934239AbYBWINm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239AbYBWINm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764516AbYBWIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:41 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932869AbYBWIIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:39 -0500
Date: Sat, 23 Feb 2008 00:06:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Cpusets API: Update cpusets to use cgroup
 structured file API
Message-Id: <20080223000631.f4c1dbf4.akpm@linux-foundation.org>
In-Reply-To: <20080220050032.396158000@menage.corp.google.com>
References: <20080220045408.289180000@menage.corp.google.com>
	<20080220050032.396158000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 20:54:10 -0800 Paul Menage <menage@google.com> wrote:

> Many of the cpusets control files are simple integer values, which
> don't require the overhead of memory allocations for reads and writes.
> 
> Move the handlers for these control files into cpuset_read_uint() and
> cpuset_write_uint(). This also has the advantage that the control
> files show up as "u64" rather than "string" in the cgroup.api file.

again, the naming here is a bit misleading - s/uint/u64/ would be clearer.

It is unclear to me what the relationship is between this and your other
cgroup pseudo-fs changes, but as this is fiddling with a userspace
interface we should get a wiggle on - we don't want to let things like this
slip out to 2.6.26.

So..  please resend everything?
