Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758359AbXFPOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbXFPOTT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sat, 16 Jun 2007 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbXFPOTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:19:04 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:35938 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbXFPOTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:19:03 -0400
Date: Sat, 16 Jun 2007 16:22:19 +0200
From: Clifford Wolf <clifford@clifford.at>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: dave young <hidave.darkstar@gmail.com>,
        "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: coding style
Message-ID: <20070616142219.GG8923@clifford.at>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jun 15, 2007 at 11:16:08AM +0200, Jan Engelhardt wrote:
> >> so which one is preferred for the kernel?
> 
> err = very_long_function_name(lots_of_arguments,
>                               less,
>                               less,
>                               less,
>                               less,
>                               even_more_arguments,
>                               more_of_this,
>                               more_of_that,
>                               more,
>                               more,
>                               more);
> 
> IMO, preferred:
> 
> err = very_long_function_name(lots_of_arguments, less, less, less, less,
>       even_more_arguments, more_of_this, more_of_that, more, more, more);

Looking at e.g. the fuction declarations in fs/namespace.c shows very well
that there seams to be no 'preferred in the kernel source' for this
question.

I presonally prefer indenting the continuation of a line with TWO
additional tabs so it is good to distinguish from a normally indented
command block. E.g.:

static int function_with_long_name(int and_many_arguments,
		int not_fitting_in_a_signle_line_anymore)
{
	if (and_many_arguments > not_fitting_in_a_signle_line_anymore &&
			not_fitting_in_a_signle_line_anymore > 0)
		and_many_arguments += not_fitting_in_a_signle_line_anymore;
	else
		not_fitting_in_a_signle_line_anymore *=
				not_fitting_in_a_signle_line_anymore;
	return and_many_arguments ^ not_fitting_in_a_signle_line_anymore;
}

maybe this won't win a design contest but it is a simple and non-ambiguous
coding style and afaics does not conflict with the CodingStyle document.

yours,
 - clifford

-- 
When your hammer is C++, everything begins to look like a thumb.
