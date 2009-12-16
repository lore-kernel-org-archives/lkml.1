Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZLPHIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZLPHIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZLPHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:08:16 -0500
Received: from smtp102.biz.mail.mud.yahoo.com ([68.142.200.237]:30880 "HELO
	smtp102.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755174AbZLPHIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:08:16 -0500
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: 5FqcbKEVM1l5U3zLAJQbuivjPDliTg4R20OiVRIR.fKxXff2V9EDdb31XLRkwA3mzcQXqgsNBDZz.mtGRHc5yrarn8U0y.FoJF9oQfJVL_kIIXV1d5ERU6I7Fq.6AwSpsytG0By3_oD4YuIsqEDf7mbo8Glo4pmjbbvzpqEKRfLaY8WpnQLcUQuHcLSkZueOgUybLr7uWYndpxFQOQiZDcAMAmvjCmkZEd_s7IhrNGkBZoItbLUmQpUFWhPNGwoeLCHBtKBf8HTubvbfLzq9M8yV2ihrGBZ1LHEKyfvDZTTzfZ2xYmYpIdPe1tUd9yOKmo0X5Tqp2ES8GDQ8kXyi7fdAxpt3GLnX3BTwHPzwaqNJ0w--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [current HEAD] commit 5ad6468801d28c4d4ac9f48ec19297817c915f6a breaks the build on m68knommu
Date: Tue, 15 Dec 2009 23:08:13 -0800
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200912151501.05552.sfking@fdwdc.com> <Pine.LNX.4.64.0912160529440.5529@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0912160529440.5529@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912152308.13468.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009 09:32:26 Hugh Dickins wrote:
> On Tue, 14 Dec 2009, Steven King wrote:
> > and I suspect on any nommu:
> >
> > In file included from kernel/fork.c:52:
> > include/linux/ksm.h:129: warning: 'enum ttu_flags' declared inside
> > parameter list
> > include/linux/ksm.h:129: warning: its scope is only this definition or
> > declaration, which is probably not what you want
> > include/linux/ksm.h:129: error: parameter 2 ('flags') has incomplete type
> > make[1]: *** [kernel/fork.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
>
> Aargh, sorry about that: I've not built this on nommu, does it fix it?

Yes,

thanks.


-- 
Steven King -- sfking at fdwdc dot com
