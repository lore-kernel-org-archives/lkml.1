Return-Path: <linux-kernel-owner+w=401wt.eu-S1765916AbXJORhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765916AbXJORhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbXJORgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:36:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24993 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbXJORgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:36:54 -0400
Message-ID: <5640c7e00710151036r62367bbj8e0fad80381b96b4@mail.gmail.com>
Date: Tue, 16 Oct 2007 06:36:51 +1300
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] net/DCCP: fix link error with !CONFIG_SYSCTL
Cc: linux-kernel@vger.kernel.org, "Gerrit Renker" <gerrit@erg.abdn.ac.uk>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20071015161113.GA569@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015161113.GA569@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Ingo Molnar <mingo@elte.hu> wrote:
> Subject: net/DCCP: fix link error with !CONFIG_SYSCTL
> From: Ingo Molnar <mingo@elte.hu>
>
> do not define the sysctl_dccp_sync_ratelimit sysctl variable in
> the CONFIG_SYSCTL dependent sysctl.c module - move it to input.c instead.
>
> this fixes the following build bug:
>
>  net/built-in.o: In function `dccp_check_seqno':
>  input.c:(.text+0xbd859): undefined reference to `sysctl_dccp_sync_ratelimit'
>  distcc[29953] ERROR: compile (null) on localhost failed
>  make: *** [vmlinux] Error 1
>
> found via 'make randconfig' build testing.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Ingo - this should go via netdev@vger.kernel.org.nz or
dccp@vger.kernel.org.nz so it gets picked up by a maintainer.

Signed-off-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
