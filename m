Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZKFReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZKFReP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZKFReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:34:14 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:37490 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755186AbZKFReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:34:14 -0500
Date: Fri, 6 Nov 2009 12:32:48 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
In-Reply-To: <20091106122344.51118116.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911061231580.5187@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1> <20091104234923.GA25306@redhat.com> <alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1> <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1> <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
 <20091106122344.51118116.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, KAMEZAWA Hiroyuki wrote:

> BTW, can't we have single-thread-mode for this counter ?
> Usual program's read-side will get much benefit.....

Thanks for the measurements.

A single thread mode would be good. Ideas on how to add that would be
appreciated.
