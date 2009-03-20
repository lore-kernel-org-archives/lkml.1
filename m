Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZCTEsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZCTEsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 00:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZCTEsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 00:48:25 -0400
Received: from kroah.org ([198.145.64.141]:53335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbZCTEsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 00:48:25 -0400
Date: Thu, 19 Mar 2009 21:18:11 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs
Message-ID: <20090320041811.GA3352@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5142.1237521581@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 12:59:41PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Greg KH:
> > > Greg KH:
> > > > Really?  Try leaving them out for now and see if anyone notices :)
> > > 
> > > Ok, then I will move them to debugfs.
> > > Does the rule "one value per file" applied to debugfs too?
> > 
> > The only rule that debugfs has is:
> > 	debugfs has no rules!
> 
> To make sure, how do you think this change?
> 
> (current)
> /sys/fs/aufs/si_<id>/
> + br0 ... brN
> + xi0 ... xiN
> + xi_path
> + xib
> + xigen
> 
> (future)
> /sys/fs/aufs/si_<id>/
> + br0 ... brN
> + xi_path
> 
> /debug/aufs/si_<id>/
> + xi0 ... xiN
> + xib
> + xigen
> xiN and xib may be consolidated into a single file.

Looks like a good start, if you are _sure_ you need sysfs files :)

thanks,

greg k-h
