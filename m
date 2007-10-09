Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXJIWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXJIWTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXJIWT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:19:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56801
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751536AbXJIWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:19:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Date: Tue, 9 Oct 2007 17:19:23 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rdunlap@xenotime.net
References: <200710090125.19089.rob@landley.net> <20071009130315.GB4245@Ahmed>
In-Reply-To: <20071009130315.GB4245@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091719.23265.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 8:03:15 am Ahmed S. Darwish wrote:
> $ man getcwd
>
>  char *getcwd(char *buf, size_t size);
>
>  As an extension to the POSIX.1 standard, Linux (libc4, libc5, glibc)
> getcwd() allocates the buffer dynamically using malloc() if buf is NULL on
> call.
>
> Shouldn't "srctree" be free()ed in case getenv("SRCTREE") failed ?

If exit() doesn't free all the memory the program allocated, we have bigger 
problems.

> Regards,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
