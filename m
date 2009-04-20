Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZDTHQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZDTHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDTHQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:16:18 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34759 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDTHQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:16:17 -0400
Date: Mon, 20 Apr 2009 09:15:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       benh@kernel.crashing.org, heiko.carstens@de.ibm.com, paulus@samba.org,
       tony.luck@intel.com, seto.hidetoshi@jp.fujitsu.com,
       jeremy@xensource.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH] /proc/stat idle field for idle cpus
Message-ID: <20090420091504.0f619d8f@skybase>
In-Reply-To: <20090417160211.4fa36fb7.akpm@linux-foundation.org>
References: <20090414141851.3174f880@skybase>
	<20090417160211.4fa36fb7.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 16:02:11 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Looks OK to me.  Please merge it via the s390 tree.
> 
> Do other architectures need to fix this?

Thanks Andrew for the quick review. Other architecture might want to
implement this as well, with tick-less the idle numbers in /proc/stat
are just way off. The implementation of the arch_idle_time is not easy
I'm afraid, the sleep time of each cpu needs to be measured in a way
that it can be read from neighbouring cpus (and it should better be a
precise). Not something I would want to have to implement for x86.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

