Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYFKPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYFKPL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760841AbYFKPLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:11:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43664 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760827AbYFKPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:11:18 -0400
Date: Wed, 11 Jun 2008 11:11:00 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080611151100.GA8066@c2.user-mode-linux.org>
References: <20080610190307.GA15983@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610190307.GA15983@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:03:07PM +0200, Sam Ravnborg wrote:
> In an attempt to make the final link of vmlinux
> readable/hackable I have broken um build.
> 
> um used a special rule so it could use gcc as linker.
> With my changes we need to use ld to link vmlinux and
> ld now fails to locate util.
> 
> I hope you have a clue why. I tried various things but
> did not find out why ld cannot locate util.

Looks to me like replacing the "-rpath foo" with -Lfoo does the trick.

I'll work up an incremental patch for this.

      	    	 Jeff

-- 
Work email - jdike at linux dot intel dot com
