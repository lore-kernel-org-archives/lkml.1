Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYDMPTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYDMPTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYDMPS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:18:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58993 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYDMPS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:18:58 -0400
Date: Sun, 13 Apr 2008 16:18:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SL Baur <steve@xemacs.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080413151845.GP9785@ZenIV.linux.org.uk>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com> <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com> <20080412002652.GM9785@ZenIV.linux.org.uk> <4801D82C.7000901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4801D82C.7000901@panasas.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 12:53:48PM +0300, Benny Halevy wrote:

> > Sorry.  I'm not going to change perfectly working editing habits *or* to patch
> 
> That's working well for you but apparently not so well for everybody else.

Nice turn of a phrase, that.

> > nvi to satisfy an annoying wunch of bankers.  HAND, GAFL.
> > --
> 
> Thanks for the insightful and mature comment, Al.

Oh, for the...

> I really hate to spend more time on this topic but folks did find merits in it.
> There's no need to change anybody's editing habits if we allow this indentation
> style in the CodingStyle document and in checkpatch.pl in addition to the
> existing convention.

"Allow" is such a nice word, isn't it?  Let's take a closer look:
	* nobody prohibits lines satisfying your constraints ("tabs only for
indent level"), so "allowing" that is meaningless
	* "indentation style" in the above refers to editor settings.
To "allow" that, you advocate prohibiting the lines _NOT_ satisfying your
constraints.  Which, by definition, means extra work for people submitting
patches, no matter how you spin it.

BTW, while we are talking about conventions, would you mind keeping lines
in your mail shorter than 79 columns to avoid wraparounds in quoted text?
Unlike your proposal, that one actually _is_ a common convention...
