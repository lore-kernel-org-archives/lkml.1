Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZKESC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZKESC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZKESC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:02:56 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:44898 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757657AbZKESC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:02:56 -0500
Date: Thu, 5 Nov 2009 10:10:56 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
In-Reply-To: <20091105101650.45204e4e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911051008260.25718@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1> <20091105101650.45204e4e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, KAMEZAWA Hiroyuki wrote:

> Hmm, I don't fully understand _new_ percpu but...
> In logical (even if not realistic), x86-32 supports up to 512 ? cpus in Kconfig.
> BIGSMP.

x86-32 only supports 32 processors. Plus per cpu areas are only allocated
for the possible processors.

> Then, if 65536 process runs, this consumes
>
> 65536(nr_proc) * 8 (size) * 512(cpus) = 256MBytes.

With 32 possible cpus this results in 16m of per cpu space use.

