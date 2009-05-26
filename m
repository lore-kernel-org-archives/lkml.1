Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZEZVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZEZVEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZEZVE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:04:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbZEZVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:04:25 -0400
Date: Tue, 26 May 2009 14:04:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, davem@davemloft.net, tgraf@suug.ch,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] cls_cgroup: read classid atomically in classifier
Message-Id: <20090526140408.6c829124.akpm@linux-foundation.org>
In-Reply-To: <20090526195840.8464.36548.stgit@menage.mtv.corp.google.com>
References: <20090526195840.8464.36548.stgit@menage.mtv.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 12:59:11 -0700
Paul Menage <menage@google.com> wrote:

> Avoid reading the unsynchronized value cs->classid multiple times,
> since it could change concurrently from non-zero to zero; this would
> result in the classifier returning a positive result with a bogus
> (zero) classid.

When this race occurs, what are the user-visible consequences?

People who need to decide to which kernels a patch should be applied
like to know such things.
