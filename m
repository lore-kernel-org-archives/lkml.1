Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYDYJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYDYJDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758086AbYDYJDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:03:11 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:22472 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756109AbYDYJDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:03:10 -0400
Date: Fri, 25 Apr 2008 18:02:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [RFC patch 8/9] SH remove -traditional
Message-ID: <20080425090207.GB30569@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org
References: <20080422172404.502954084@polymtl.ca> <20080422172843.205481136@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422172843.205481136@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:24:12PM -0400, Mathieu Desnoyers wrote:
> Subject: [RFC patch 8/9] Re: [PATCH] Stringify support commas
>  > This is a no-no for those archs that still use -traditional.
>  > > I dunno if this is a problem for you at the moment and the
>  > > right fix is anyway to nuke -traditional.
>  > > 
>  > >     Sam
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Sam Ravnborg <sam@ravnborg.org>
> CC: lethal@linux-sh.org
> CC: linux-sh@vger.kernel.org
> ---
>  arch/sh/boot/compressed/Makefile_32 |    1 -
>  arch/sh/boot/compressed/Makefile_64 |    1 -
>  2 files changed, 2 deletions(-)
> 
Oops, these must have snuck back in during the sh64 integration, I
thought I had killed them all off already. Applied, thanks.
