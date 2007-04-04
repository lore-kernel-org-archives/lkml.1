Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbXDDRtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbXDDRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXDDRtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:49:00 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42280 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXDDRsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:48:42 -0400
Date: Wed, 4 Apr 2007 19:48:29 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-Id: <20070404194829.1a93d8fd.dada1@cosmosbay.com>
In-Reply-To: <20070404172931.GM2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 10:29:31 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> It is not now possible for a thread to retrieve its own rusage in
> isolation. Its rusage is nowhere exposed without being intermixed with
> that of its sibling threads. This patch adds support for an
> RUSAGE_THREAD who argument that returns rusage for only the desired
> thread.
> 

Please check mm, because we now return ru_inblock and ru_oublock as well.

r->ru_inblock = task_io_get_inblock(p);
r->ru_oublock = task_io_get_oublock(p);

