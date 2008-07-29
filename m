Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYG2D0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYG2D0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYG2D0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:26:41 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:57305 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYG2D0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:26:40 -0400
Date: Tue, 29 Jul 2008 05:27:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080729032726.GA27460@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <20080729030647.GA11425@phobos.i.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729030647.GA11425@phobos.i.cabal.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:06:47PM -0400, Kyle McMartin wrote:
> On Mon, Jul 28, 2008 at 10:05:00PM +0200, Sam Ravnborg wrote:
> > I am limited in time and resources at the moment but I
> > would be glad to help out as time permits should there
> > be any questions.
> > 
> 
> Just a quick one... I moved the files on parisc, but found we're still
> using include/asm-$foo/asm-offsets.h. A quick glance at Kbuild seems to
> indicate so. Is this expected?
Yes.

asm-offsets.h is a generated file and I wanted to avoid adding
generated files to arch/$ARCH/include.

It was also a less intrusive patch to keep it at the old location.
But I recall that it troubles me a bit before I got it
correct but the kbuild changes all take care of this.

	Sam
