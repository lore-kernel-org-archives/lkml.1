Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYECNYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYECNYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYECNYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:24:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYECNYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:24:20 -0400
Date: Sat, 3 May 2008 09:23:27 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: preempt-rt, need old style rwlocks for systemtap
Message-ID: <20080503132327.GA28881@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

It has come to my attention that the preempt-rt patch suite
deliberately defeats the potential concurrency intended by systemtap's
use of rwlocks to permit concurrent readers of various data
structures.  Since systemtap's probe handlers are all atomic,
nonblocking, nonpreemptable, it does not seem like there is any
real-time-oriented benefit in this.  What can we do to work around
this and permit reader concurrency again in preempt-rt?

- FChE
