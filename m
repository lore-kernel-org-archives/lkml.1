Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbZEKVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbZEKVSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZEKVSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:18:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbZEKVSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:18:02 -0400
Date: Mon, 11 May 2009 14:11:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.ziljstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11 -mmotm] oom: fix possible oom_dump_tasks NULL
 pointer
Message-Id: <20090511141138.3e8118ab.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 15:07:16 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
> pointer for tasks that have detached mm's since task_lock() is not held
> during the tasklist scan.

ok.  But a better changelog would have told us how the patch fixes the
problem?


This patch series is partially core MM and partially drivers/staging. 
I don't normally handle staging things, so I'd need to be cherrypicking
from this lot.  Is there any interdependency between the two things?


