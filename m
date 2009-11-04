Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZKDTQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZKDTQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZKDTQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:16:28 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:42961 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757876AbZKDTQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:16:27 -0500
Date: Wed, 4 Nov 2009 14:15:40 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] show per-process swap usage via procfs
In-Reply-To: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:

> Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> RSS usage is important information but one more information which
> is often asked by users is "usage of swap".(user support team said.)

Hmmm... Could we do some rework of the counters first so that they are per
cpu?

