Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZDUPHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZDUPHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZDUPHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:07:46 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:58477 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZDUPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:07:45 -0400
Date: Tue, 21 Apr 2009 10:59:43 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/25] Calculate the cold parameter for allocation only
 once
In-Reply-To: <20090421180551.F142.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0904211058270.19969@qirst.com>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-12-git-send-email-mel@csn.ul.ie> <20090421180551.F142.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, KOSAKI Motohiro wrote:

> It seems benefit is too small. It don't win against code ugliness, I think.

Some of these functions are inlined by the processor. And it helps the
compiler to optimize if the state is in a local variable.
