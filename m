Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYLSWLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYLSWLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbYLSWAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:00:39 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:44638 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbYLSWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:00:38 -0500
Date: Fri, 19 Dec 2008 23:02:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Message-ID: <20081219220210.GB3090@uranus.ravnborg.org>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain> <20081216181133.2342b49e@lxorguk.ukuu.org.uk> <20081216183817.GA25108@uranus.ravnborg.org> <20081217100727.5cf6248c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217100727.5cf6248c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:07:27AM +0000, Alan Cox wrote:
> 
> > Smells like a kbuild issue.
> > Please copy me and linux-kbuild@vger.kernel.org on any findings.
> > 
> > [My 64 bit toolchain is br0ken atm so I could not try to reproduce]
> 
> Yes I do indeed need to build x86_64 first, then make distclean or
> mrproper and then 32bit build fails

Hi Alan.

Can I ask you to persuade this a bit more?

1) when it fails try using "make V=1" and post the command executed.
1a) Do the same when it works and compare the two
2) try to do: make path/file.i and check if the generated .i file
   differ when it fails and when it is ok.

Other than that I have no ideas for the moment.

	Sam
