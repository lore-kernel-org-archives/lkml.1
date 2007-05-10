Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbXEJMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbXEJMuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbXEJMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:49:56 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48111 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbXEJMtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:49:55 -0400
Date: Thu, 10 May 2007 21:49:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Roland Dreier <rolandd@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: trivial MLX4_DEBUG dependency fix.
Message-ID: <20070510124926.GB18534@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roland Dreier <rdreier@cisco.com>,
	Roland Dreier <rolandd@cisco.com>, linux-kernel@vger.kernel.org
References: <20070510035028.GA26453@linux-sh.org> <aday7jw29ci.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday7jw29ci.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 04:42:37AM -0700, Roland Dreier wrote:
>  > CONFIG_MLX4_DEBUG works out to a def_bool y for those that
>  > have CONFIG_EMBEDDED set. Make it depend on MLX4_CORE..
> 
> Thanks, applied...  (by the way, this bug just results in an
> extraneous CONFIG variable being defined, right?  There's no further
> breakage -- or am I misunderstanding the situation?)
> 
Correct, there was no real breakage, just the extraneous variable.
SLUB_DEBUG had the same symptoms, which is why I referenced it ;-)

>  > I'll let someone else wonder why debugging output is default enabled,
>  > this seems to be a worrying trend as of late.
> 
> Actually this option just controls whether to build the debugging
> output at all.  The output is controlled at runtime with a module
> parameter (which can be changed via sysfs after the module is loaded),
> and the output defaults to off.
> 
> The reason why I want building the debugging stuff to default to y is
> so that distros automatically build modules with debugging enabled.
> Otherwise it's a pain to try and gather info from someone who has
> problems with a kernel they didn't build.
> 
That's more reasonable at least. Thanks for the clarification.
