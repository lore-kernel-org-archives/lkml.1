Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXFORd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXFORd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbXFORdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:33:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:6884 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXFORdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Qy7TzHSX6eWTI8IYjhLrZuUox1rXyfb2w7FBeJfqwDycXmAs8XkkKcU8QJasz9JhT/HHtmCIDcnGCO9BEcdINrRrTGFnLeXQppG/yRd3I5/tX1tHCaAERNE56AxsrGG+UPqByvZdds4j5yJJSXgIvySrh4+7BEXggyJAZQhAS3E=
Date: Fri, 15 Jun 2007 21:32:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: dave young <hidave.darkstar@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: coding style
Message-ID: <20070615173206.GA8151@cvg>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Engelhardt - Fri, Jun 15, 2007 at 11:16:08AM +0200]
| 
| 
| Cyrill wrote:
| >>      err = foo(arg_a, arg_b, arg_c,
| >>                arg_d);
|   1    23        4
| 
| (note: monospace font needed)
| 
| 
| Dave wrote:
| > The Documentation/CodingStyle says:
| >
| > Outside of comments, documentation and except in Kconfig, spaces are never
| > used for indentation, and the above example is deliberately broken.
| 
| Everything is right. The indent only goes from "1" to "2" [see above], 
| "3" to "4" is called
| 
| 	Cyrill wrote:
| 	>> [spaces only for] alignment
| 
| Cyrill wrote:
| >> so which one is preferred for the kernel?
| 
| err = very_long_function_name(lots_of_arguments,
|                               less,
|                               less,
|                               less,
|                               less,
|                               even_more_arguments,
|                               more_of_this,
|                               more_of_that,
|                               more,
|                               more,
|                               more);
| 
| IMO, preferred:
| 
| err = very_long_function_name(lots_of_arguments, less, less, less, less,
|       even_more_arguments, more_of_this, more_of_that, more, more, more);
| 
| YMMV.
| 
| 
| 	Jan
| -- 
| 

Thanks to all of you for answering. Actually I was concerning about function
arguments' alignment (on separated lines) not about indentation. So as I see
it's a question of bent ;) And a simple rule exist - use tabs for indents
and spaces for alignment (when amount of spaces are < 8).

		Cyrill

