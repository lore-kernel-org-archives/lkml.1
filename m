Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbXGSVBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbXGSVBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbXGSVAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:00:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862AbXGSVAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:00:54 -0400
Date: Thu, 19 Jul 2007 14:00:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Zankel <czankel@tensilica.com>
Cc: torvalds@linux-foundation.org, chris@zankel.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix modpost warnings for xtensa
Message-Id: <20070719140005.863f7ffa.akpm@linux-foundation.org>
In-Reply-To: <200707191837.l6JIbuE25527@corvus.hq.tensilica.com>
References: <200707191837.l6JIbuE25527@corvus.hq.tensilica.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 11:37:56 -0700
Chris Zankel <czankel@tensilica.com> wrote:

> 
> 	[PATCH] fix modpost warnings for xtensa
> 
> 	The Xtensa architecture places literal pools in sections separate 
> 	from the instructions. The corresponsing text sections, therefore, 
> 	reference the .literal section, and we have to suppress those
> 	warnings. The naming convention defines the name for a literal 
> 	section as .SECTION.literal, unless .SECTION is .text. In that case
> 	the name is only .literal. Using strncmp() instead of strcmp() 
> 	to compare the from-section with .SECTION.init.refok in pattern 0
> 	should not cause any regressions for other architectures.
> 	We also need to suppress warnings for two informational 
> 	sections (.xt.lit and .xt.prop) used by the Xtensa architecture.

This generates unfixable-by-me rejects against Sam's git-kbuild tree.
Sam already had a pull request into Linus for that tree.  Could I ask
that you wait for that piece of dust to settle and then regenerate the
diff?

Thanks.
