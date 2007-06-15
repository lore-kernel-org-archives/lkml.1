Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbXFOEv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbXFOEv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 00:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXFOEvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 00:51:18 -0400
Received: from 1wt.eu ([62.212.114.60]:3009 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXFOEvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 00:51:18 -0400
Date: Fri, 15 Jun 2007 06:51:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
Message-ID: <20070615045111.GU943@1wt.eu>
References: <20070614184836.GA6520@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614184836.GA6520@cvg>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 10:48:36PM +0400, Cyrill Gorcunov wrote:
> 
> Hi to all,
> 
> a simple question the answer to witch I didn't find in CodingStyle.
> Look for a code snip:
> 
> 	err = foo(arg_a, arg_b, arg_c,
> 		arg_d);
> 
> the second line contains 'd' arg aligned with tabs only
> but it could be rewritten with more elegant style (by adding
> a few spaces) like this
> 
> 	err = foo(arg_a, arg_b, arg_c,
> 		  arg_d);
> 
> so which one is preferred for the kernel?

There is no "preferred", just one good and one bad :-)

Ideally, you should use tabs only for indentation, and spaces only for
alignment. Keep in mind that there are people using different tab sizes
and that your tabs should not make it harder for them to read your code.
In your example above, you should use tabs from left up to "err", then
spaces to go from "err" to "arg_d".

However, we know that some editors such as emacs are stupid in this regard,
because they fill with tabs then complete with spaces, so it's not always
easy.

Regards,
Willy

