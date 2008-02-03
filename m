Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbYBCMRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbYBCMRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760493AbYBCMRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:17:07 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44977 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759905AbYBCMRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:17:06 -0500
Date: Sun, 3 Feb 2008 13:17:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: restore correct module name for apm
Message-ID: <20080203121709.GE20810@uranus.ravnborg.org>
References: <47A4E70D.1000607@ntlworld.com> <20080203103213.GC20810@uranus.ravnborg.org> <47A5AAF0.6090402@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A5AAF0.6090402@ntlworld.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 11:52:16AM +0000, A.E.Lawrence wrote:
> Sam Ravnborg wrote:
> > The apm module were renamed to apm_32 during the merge of 32 and 64 bit x86 which
> > is unfortunate.
> > As apm is 32 bit specific we like to keep the _32 in the filename
> > but the module should be named apm.
> > 
> > Fix this in the Makefile.
> > Reported by "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
> 
> ..snip..
> > 
> > build tested only but obviously correct.
> > 
> > 	Sam
> 
> It is also at
>   http://bugzilla.kernel.org/show_bug.cgi?id=9877
> which someone (me?) should probably now close.

I please do so.
But I think you should wait until it hits mainline

	Sam
