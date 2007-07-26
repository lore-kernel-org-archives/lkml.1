Return-Path: <linux-kernel-owner+w=401wt.eu-S935766AbXGZVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935766AbXGZVox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764696AbXGZVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:44:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762970AbXGZVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:44:43 -0400
Date: Thu, 26 Jul 2007 14:44:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
Message-Id: <20070726144406.63c07909.akpm@linux-foundation.org>
In-Reply-To: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 14:37:02 -0700 Josh Triplett <josht@linux.vnet.ibm.com> wrote:

> Sparse warns about do-while loops without braces; Linus's rationale from the
> Sparse Git changelog:
> > Add warning message for naked do-while
> >
> > Does it necessarily make sense? Dunno, but it does tend to be bad
> > practice, or at least result in code that can be hard to mentally parse.
> >
> > Maybe that mental parsing is just me.	 Or maybe it should be warned
> > about. You decide.
> 
> Signed-off-by: Josh Triplett <josh@kernel.org>
> ---
>  Documentation/CodingStyle |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 7f1730f..f12e4b8 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -175,6 +175,13 @@ if (condition) {
>  	otherwise();
>  }
>  
> +This also does not apply to a do-while loop; always use braces with a do-while,
> +even if it contains a single statement:
> +
> +do {
> +	this();
> +} while(condition);
> +

err, your example has broken coding style.
