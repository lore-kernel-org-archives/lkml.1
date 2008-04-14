Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYDNU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYDNU7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYDNU65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:58:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40131 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbYDNU65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:58:57 -0400
Date: Mon, 14 Apr 2008 22:59:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 vDSO: compile with -g
Message-ID: <20080414205926.GB16416@uranus.ravnborg.org>
References: <20080414191930.B2D9F26FA5F@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414191930.B2D9F26FA5F@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 12:19:30PM -0700, Roland McGrath wrote:
> The 64-bit vDSO's sources are compiled with -g0 for no good reason.
> Using -g when enabled lets their separate debug files be used at
> runtime via build ID matching, same as we can see 32-bit vDSO's
> assembly sources.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
Looks good.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
[I have not tested it]

	Sam
