Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYIAHja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYIAHja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYIAHjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:39:21 -0400
Received: from vuizook.err.no ([194.24.252.247]:46485 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbYIAHjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:39:20 -0400
Date: Mon, 1 Sep 2008 09:38:45 +0200
From: Mike Hommey <mh@glandium.org>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Tejun Heo <tj@kernel.org>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
Message-ID: <20080901073844.GA5376@glandium.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org> <20080829055000.GB18930@glandium.org> <48B78EBA.609@kernel.org> <3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com> <48B93D68.6040506@kernel.org> <20080830185613.GC12546@glandium.org> <87iqtggwng.fsf@frosties.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqtggwng.fsf@frosties.localdomain>
Organization: glandium.org
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mh@glandium.org
X-SA-Exim-Scanned: No (on vaio.glandium.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 09:20:19AM +0200, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> Mike Hommey <mh@glandium.org> writes:
> 
> > On Sat, Aug 30, 2008 at 02:30:32PM +0200, Tejun Heo wrote:
> >> Yeah, compared to loopback over FUSE, anything would have less
> >> problem. :-) I don't know much about nbd but it's pretty much solving
> >> the same problem so I think it's logical to extend nbd including
> >> giving it a new transport if necessary?  Or is there something
> >> fundamentally better when it's done via FUSE?
> >
> > My gutt feeling is that it would have less overhead when done via FUSE
> > than through nbd, but that could be wrong.
> >
> > Mike
> 
> What I would hope is that BUSE would add some zero copy transport in
> there. A way to just redirect the BIOs from the BUSE device to other
> block devices without copying the data around.
> 
> But maybe BUSE is a bad name for that. That would be more a DUSE -
> Device mapper in USEr space.

That already exists. http://wiki.xensource.com/xenwiki/DmUserspace

Mike
