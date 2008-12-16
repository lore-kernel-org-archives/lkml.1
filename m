Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYLPVaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYLPVaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYLPVaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:30:06 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:55774 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYLPVaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:30:05 -0500
Message-ID: <49481DC5.4000404@oracle.com>
Date: Tue, 16 Dec 2008 13:29:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel function documentation question
References: <20081216211824.GG12431@fluff.org.uk>
In-Reply-To: <20081216211824.GG12431@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49481DB6.0165:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> The Documentation/kernel-doc-nano-HOWTO.txt says that functions
> should be documented as so:

That's an example.  There is no "should" with that example.

> /**
>  * foobar() - short function description of foobar
> 
> I notice there are a number of places that ommit the () off the
> foobar, for example:
> 
> include/linux/skbuff.h, line 461:
> 
> /**
>  *	skb_get - reference buffer
>  *	@skb: buffer to reference
> 
> where skb_get does not have ()s.

That's perfectly fine.  The "formal" syntax is given later in that file:

The format of the block comment is like this:

/**
 * function_name(:)? (- short description)?
(* @parameterx(space)*: (description of parameter x)?)*
(* a blank line)?
 * (Description:)? (Description of function)?
 * (section header: (section description)? )*
(*)?*/


and those parentheses are (confusing) grouping characters, not literals.  :(


> As a note, it seems the default debian emacs does not colour the
> function name unless it ends ().

File a bug with debian?

> Also, is there any policy on tabs vs a single space for indenting
> these comments?

Nope.  I prefer a single space, but some people seem to prefer tab(s).

~Randy
