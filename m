Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYH3S4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYH3S4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYH3S4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:56:35 -0400
Received: from vuizook.err.no ([194.24.252.247]:32902 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbYH3S4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:56:34 -0400
Date: Sat, 30 Aug 2008 20:56:13 +0200
From: Mike Hommey <mh@glandium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Archie Cobbs <archie@dellroad.org>, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
Message-ID: <20080830185613.GC12546@glandium.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org> <20080829055000.GB18930@glandium.org> <48B78EBA.609@kernel.org> <3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com> <48B93D68.6040506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B93D68.6040506@kernel.org>
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
Organization: glandium.org
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 02:30:32PM +0200, Tejun Heo wrote:
> Hello,
> 
> Archie Cobbs wrote:
> >> Thought about that but it's really no different from nbd or loop
> >> depending on your application and block devices don't really implement
> >> the file operations so it won't have too much in common with FUSE.
> > 
> > I think BUSE would be useful. For one, it allows you to avoid problems with
> > the extra caching you get with a loopback device. And NBD is too limiting
> > for some applications.
> > 
> > For my half-ignorant analysis of the caching issues, see:
> >   http://code.google.com/p/s3backer/wiki/PerformanceConsiderations#Caching
> > 
> > This is also an example of an application where NBD doesn't suffice.
> > 
> >> Also, there's the complication of going out to disk for more memory cases.
> > 
> > Not sure what you mean exactly (my fault), but it seems BUSE would have fewer
> > places for memory problems (including deadlocks) than loopback over FUSE,
> > which is the only way to do this kind of stuff now.
> 
> Yeah, compared to loopback over FUSE, anything would have less
> problem. :-) I don't know much about nbd but it's pretty much solving
> the same problem so I think it's logical to extend nbd including
> giving it a new transport if necessary?  Or is there something
> fundamentally better when it's done via FUSE?

My gutt feeling is that it would have less overhead when done via FUSE
than through nbd, but that could be wrong.

Mike
