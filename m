Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZJFRq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZJFRq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbZJFRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:46:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZJFRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:46:25 -0400
Subject: Re: Linux 2.6.32-rc3
From: Dirk Hohndel <hohndel@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <20091006144449.GA23078@elte.hu>
	 <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
	 <20091006153632.GA29795@elte.hu>
	 <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 06 Oct 2009 10:45:32 -0700
Message-Id: <1254851132.24117.30.camel@dhohndel-mobl.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 09:31 -0700, Linus Torvalds wrote:
> 
> On Tue, 6 Oct 2009, Linus Torvalds wrote:
> > 
> > Unless:
> > 
> > > _That_ i think is a lot harder to confuse with the real .31 than a 
> > > v2.6.31-1234-g16123c4 version string.
> > 
> > .. are you saying that it would be just some automatically generated 
> > thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
> > CONFIG_LOCALVERSION_AUTO_SHORTFORM?

That's much better than what I had suggested - and it would work for
your case with multiple trees in a sane manner as well.

> IOW, you'd never get 2.6.32-rc0, but you'd get either the complex git 
> version number (or SVN/hg/whatever), or at least "2.6.31+" with the "+" 
> showing that it is more than plain 2.6.31.
> 
> The "+" could be anything else, of course. The diff is pretty obvious, you 
> can argue about exactly _what_ you'd like to see as a suffix for "and then 
> some".

The argument by Stefan Richter that '+' is already used informally as
"or later" is somewhat valid - maybe we could use an ampersand (which
originally stood for 'et cetera' - and other things). 

But then I don't know if that would confuse tons of scripts as the & has
lots of other meanings in various scripting languages.

-- 
Dirk Hohndel
Intel Open Source Technology Center

