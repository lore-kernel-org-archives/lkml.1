Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZD3LD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZD3LD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZD3LDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:03:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49072 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZD3LDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:03:16 -0400
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090430103654.GB6900@wotan.suse.de>
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org>
	 <5622.1240628800@turing-police.cc.vt.edu>
	 <20090425052434.GE10088@wotan.suse.de>
	 <57773.1240857915@turing-police.cc.vt.edu>
	 <20090428061557.GA29299@wotan.suse.de>
	 <20954.1240934481@turing-police.cc.vt.edu>
	 <20090430103654.GB6900@wotan.suse.de>
Date: Thu, 30 Apr 2009 14:03:14 +0300
Message-Id: <1241089394.19252.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 12:36 +0200, Nick Piggin wrote:
> On Tue, Apr 28, 2009 at 12:01:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 28 Apr 2009 08:15:57 +0200, Nick Piggin said:
> > 
> > Here's the code (pretty much *all* the code):
> > 
> > > #include <linux/version.h>
> > > #include <linux/utsname.h>
> > > int main() {
> > > 	if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
> > > 		return 0;
> > > 	} else {
> > > 		return 1;
> > > 	}
> > > }
> > 
> > > Hmm, yes if you build without -O, then it appears like the compiler
> > > trips over this. I wouldn't be unhappy with just removing the BUILD_BUG_ON,
> > > but shouldn't the module be using -O[s2]?
> > 
> > It's a little autoconfig chunk from vendor code that determines if we're
> > building on a sane/recent kernel.  Not the sort of thing you'd expect to
> > need to invoke the frikking optimizer for program *correctness* :)
> > 
> > 
> 
> Pekka, can you apply this please?

Applied, thanks!

