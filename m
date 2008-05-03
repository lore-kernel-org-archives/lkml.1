Return-Path: <linux-kernel-owner+w=401wt.eu-S1764748AbYECRRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764748AbYECRRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbYECRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:17:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759712AbYECRR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:17:26 -0400
Date: Sat, 3 May 2008 13:16:27 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: preempt-rt, need old style rwlocks for systemtap
Message-ID: <20080503171627.GC23961@redhat.com>
References: <20080503132327.GA28881@redhat.com> <481C77E8.8050002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481C77E8.8050002@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, May 03, 2008 at 09:34:16AM -0500, Clark Williams wrote:
> [...]
> > It has come to my attention that the preempt-rt patch suite
> > deliberately defeats the potential concurrency intended by systemtap's
> > use of rwlocks to permit concurrent readers [...]

> The reason it "defeats" the concurrent behavior is that it's really
> complicated to have concurrent readers with Priority Inheritance, so
> the initial cut of rtmutexes serialized all lock accesses. [...]

Do you believe priority inheritance to be an essential property of
every use of these primitives, regardless of the nature of the
specifical critical sections being protected?  Is there no way & need
to opt out of the extra machinery?

- FChE
