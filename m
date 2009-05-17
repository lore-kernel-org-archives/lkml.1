Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZEQFu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZEQFu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 01:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZEQFuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 01:50:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbZEQFuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 01:50:12 -0400
Date: Sat, 16 May 2009 22:49:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
       Robert Richter <robert.richter@amd.com>
Subject: Re: oprofile: WQ on CPU0, prefer CPU1
Message-Id: <20090516224947.05067f96.akpm@linux-foundation.org>
In-Reply-To: <20090514202214.14243n1debrzobx2@mail.your-server.de>
References: <20090514202214.14243n1debrzobx2@mail.your-server.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added, from MAINTAINERS)

On Thu, 14 May 2009 20:22:14 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:

> 
> After suspend and resume to/from S3 I see a lot of these messages in  
> the kernel log:
> 
> [11750.054031] WQ on CPU0, prefer CPU1
> [11750.154023] WQ on CPU0, prefer CPU1
> [11750.254022] WQ on CPU0, prefer CPU1
> [11750.354022] WQ on CPU0, prefer CPU1
> [11750.454018] WQ on CPU0, prefer CPU1
> [11750.554022] WQ on CPU0, prefer CPU1
> [11750.654022] WQ on CPU0, prefer CPU1
> [11750.754039] WQ on CPU0, prefer CPU1
> [11750.854020] WQ on CPU0, prefer CPU1
> [11750.954024] WQ on CPU0, prefer CPU1
> [11751.054029] WQ on CPU0, prefer CPU1
> [11751.154028] WQ on CPU0, prefer CPU1
> [11751.254026] WQ on CPU0, prefer CPU1
> [11751.354019] WQ on CPU0, prefer CPU1
> [11751.454022] WQ on CPU0, prefer CPU1
> [11751.554032] WQ on CPU0, prefer CPU1
> [11751.654028] WQ on CPU0, prefer CPU1
> [11751.754028] WQ on CPU0, prefer CPU1
> [11751.854033] WQ on CPU0, prefer CPU1
> [11751.954029] WQ on CPU0, prefer CPU1
> [and so on; seems not to stop]
> 
> This comes from drivers/oprofile/cpu_buffer.c
> 
> Bug or feature?
> 

Don't know.  It needs fixing though - the kernel shouldn't blurt random
printks like this.

> 
> PS: 2.6.30-rc5

Do you know if earlier kernels did the same thing?
