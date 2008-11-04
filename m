Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYKDU7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYKDU7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYKDU7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:59:03 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:53410 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbYKDU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:59:02 -0500
Date: Tue, 4 Nov 2008 14:58:31 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <1225831988.7803.1939.camel@twins>
Message-ID: <Pine.LNX.4.64.0811041455130.23418@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
  <20081104124753.fb1dde5a.akpm@linux-foundation.org> <1225831988.7803.1939.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Peter Zijlstra wrote:

> I think the main reason is that we have per-node vmstats so the cpuset
> extention is relatively easy. Whereas we do not currently maintain
> vmstats on a cgroup level - although I imagine that could be remedied.

We have a separate LRU for the control groups so we are on the way 
there.


