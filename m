Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbYDNU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbYDNU61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYDNU6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:58:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39740 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYDNU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:58:19 -0400
Date: Mon, 14 Apr 2008 22:58:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Pageflags: Standardize comment inclusion in asm-offsets.h and fix MIPS
Message-ID: <20080414205847.GA16416@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:43:08AM -0700, Christoph Lameter wrote:
> Add the ability to pass comments into asm-offsets.h by generating asm
> output like
> 
> -># comment line
> 
> Mips needs this feature to preserve the comments that are in asm-mips/asm-offsets.h
> right now.
> 
> Then remove the special handling for mips from Kbuild and convert mips to use
> the new string to include the comments.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

My sedfu is not enough to properly review this.
And I am not yet able to test it.

But the general principle is good and I really like to see mips
aligned with the rest!

	Sam
