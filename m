Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZEYPQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZEYPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZEYPQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:16:49 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:39902 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZEYPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:16:48 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: What Distro is best for Starting Kernel Dev?
Date: Mon, 25 May 2009 10:16:43 -0500
User-Agent: KMail/1.9.9
Cc: Rik van Riel <riel@redhat.com>, John Walsh <server422@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <9f7f2c020905221910m2ffe4c53v8fd5dbc6cd236602@mail.gmail.com> <4A1819CB.9010104@redhat.com> <20090525090112.3919d117@bike.lwn.net>
In-Reply-To: <20090525090112.3919d117@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251016.46366.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon May 25 2009, Jonathan Corbet wrote:
> On Sat, 23 May 2009 11:44:11 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > John Walsh wrote:
> > > What Distro is best for Starting Kernel Dev?  
> > 
> > If you want to learn more about the system than
> > anybody should ever need to know, you can stick
> > with a bleeding-edge development distro like
> > Fedora Rawhide, Mandriva Cooker or Debian Unstable.
> 
> I do the bulk of my work on such distributions, but if you're really
> wanting to get started with *kernel* development, there is one thing to
> be aware of: development distributions can be an independent source of
> instability/weirdness in a system.  If you're at an early stage with the
> kernel, you may want to minimize the number of variables which can be
> changing at once.  So it might make more sense to base your work on a
> distribution which is not changing underneath you.
> 

One of the major "outside" variables is the tool-chain you use - -
For that reason, I suggest you use one of the "Build From Source"
distributions.  At least you know your tool chain is working.  ;)

Personally, I use both 32-bit and 64-bit Gentoo.
Also, I avoid doing any updates that would change the tool chain
while in the midst of trouble shooting something.
Just keep your hands off of the --update button. ;)

Currently (both flavors, 32/64):
gen2-32# gcc-config -l
 [1] i686-pc-linux-gnu-4.1.2 *
 [2] i686-pc-linux-gnu-4.3.2

The 4.1.2 tool chain is "good" across the board for all Gentoo archs.
The 4.3.2 tool chain is not marked as "good" for hp-parisc.

Mike

> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


