Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbXEXQ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbXEXQ53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXEXQ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:57:22 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43112
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXEXQ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:57:21 -0400
From: Rob Landley <rob@landley.net>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: Status of CONFIG_FORCED_INLINING?
Date: Thu, 24 May 2007 12:55:06 -0400
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
References: <200705231510.52932.rob@landley.net> <ada7iqz9qlj.fsf@cisco.com> <Pine.LNX.4.64.0705240836340.4500@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705240836340.4500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241255.07300.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 8:38 am, Robert P. J. Day wrote:
> On Wed, 23 May 2007, Roland Dreier wrote:
> 
> >  > - every static function in a header file must be __always_inline
> >
> > Why?  Why does it matter whether a function is defined in a .h file or
> > a .c file?  Can't the compiler decide better than we can whether
> > something should be inlined or not?
> >
> > Your argument seems to imply that we should never use the inline
> > keyword at all.

Do we ever use the "register" keyword anymore?  I don't make "suggestions" to 
gcc, I hit it with a clue-by-by four.

> i hate to be in the middle of one of these again, but i think i
> initiated this topic way back when when i (like rob landley) asked why
> that config option was still around when it's been listed for deletion
> for a year.

I'm actually trying to write documentation on it.  Temporary copy at:

http://landley.net/kdocs/inline.html

> regardless of its good or bad points, one way or the other, something
> should be updated.

I'd be happy to just figure out what the policy is.  It seems like 
the "inline" keyword should no longer be used, and either say __always_inline 
or leave it to the compiler.  If there's a good counter-argument, I'd love to 
hear it.

Rob
