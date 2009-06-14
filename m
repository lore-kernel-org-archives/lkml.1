Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbZFNUqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbZFNUqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbZFNUqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:46:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39427 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125AbZFNUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:46:31 -0400
Date: Sun, 14 Jun 2009 22:48:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kbuild: some scripts/config improvements (try 2)
Message-ID: <20090614204849.GD3187@uranus.ravnborg.org>
References: <20090525144320.GA22686@sepie.suse.cz> <20090603192520.GC3100@uranus.ravnborg.org> <20090603201645.GG1065@one.firstfloor.org> <20090604054708.GA2241@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604054708.GA2241@sepie.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 07:47:08AM +0200, Michal Marek wrote:
> On Wed, Jun 03, 2009 at 10:16:46PM +0200, Andi Kleen wrote:
> > On Wed, Jun 03, 2009 at 09:25:20PM +0200, Sam Ravnborg wrote:
> > > On Mon, May 25, 2009 at 04:43:20PM +0200, Michal Marek wrote:
> > > > Hi,
> > > > 
> > > > I simplified the awk script a bit, made it awk ... && mv and removed the
> > > > --set option.
> > > > 
> > > > Michal Marek (3):
> > > >   kbuild: handle non-existing options in scripts/config
> > > >   kbuild: simplify argument loop in scripts/config
> > > >   kbuild: add generic --set-str option to scripts/config
> > > 
> > > Andi - do I have your ack on this serie?
> > 
> > Reluctantly -- most bits are ok, but the awk change seems quite overcomplicated
> > and I don't like it particularly.
> 
> What about this one? The other two patches apply apply at slightly
> different offsets.
> 
> Subject: [PATCH 1/3] kbuild: handle non-existing options in scripts/config
> 
> If an option does not exist in .config, set it at the end of the file.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Looked readable - compared to the awk stuff.
I have applied all three patches.

	Sam
