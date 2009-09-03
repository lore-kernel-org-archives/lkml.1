Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbZICU4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbZICU4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbZICU4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:56:44 -0400
Received: from fifo99.com ([67.223.236.141]:33016 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245AbZICU4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:56:44 -0400
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
From: Daniel Walker <dwalker@fifo99.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       roland@redhat.com, rth@redhat.com, mingo@elte.hu
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
References: <cover.1252007851.git.jbaron@redhat.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 13:45:06 -0700
Message-Id: <1252010706.9808.19.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 16:25 -0400, Jason Baron wrote:
> hi,
> 
> Problem:
> 
> Currenly, tracepoints are implemented using a conditional. The conditional
> check requires checking a global variable for each tracepoint. Although,
> the overhead of this check is small, it increases under memory pressure. As we
> increase the number of tracepoints in the kernel this may become more of an
> issue. In addition, tracepoints are often dormant (disabled), and provide no
> direct kernel functionality. Thus, it is highly desirable to reduce their
> impact as much as possible. Mathieu Desnoyers has already suggested a number of
> requirements for a solution to this issue.

Could you run your patches though scripts/checkpatch.pl and clean up any
errors.. It looks like you have some style issues in a few of the
patches.

Daniel

