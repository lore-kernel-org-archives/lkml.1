Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYCLXDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYCLXDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYCLXDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:03:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbYCLXDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:03:35 -0400
Date: Wed, 12 Mar 2008 16:03:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [patch 03/10] sched: add exported arch_reinit_sched_domains()
 to header file.
Message-Id: <20080312160328.50cecd7f.akpm@linux-foundation.org>
In-Reply-To: <20080312173216.861331041@de.ibm.com>
References: <20080312173155.703966894@de.ibm.com>
	<20080312173216.861331041@de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 18:31:58 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +extern int arch_reinit_sched_domains(void);
> +#endif

I tend to recommend that the ifdefs be omitted here.

It has the downside that the build will then fail at link-time rather than
at compile-time, but I haven't seen anyone complain about that.


