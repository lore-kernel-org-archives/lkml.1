Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZFCUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZFCUJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZFCUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:09:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49136 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZFCUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:09:31 -0400
Date: Wed, 3 Jun 2009 22:16:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kbuild: some scripts/config improvements (try 2)
Message-ID: <20090603201645.GG1065@one.firstfloor.org>
References: <20090525144320.GA22686@sepie.suse.cz> <20090603192520.GC3100@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603192520.GC3100@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 09:25:20PM +0200, Sam Ravnborg wrote:
> On Mon, May 25, 2009 at 04:43:20PM +0200, Michal Marek wrote:
> > Hi,
> > 
> > I simplified the awk script a bit, made it awk ... && mv and removed the
> > --set option.
> > 
> > Michal Marek (3):
> >   kbuild: handle non-existing options in scripts/config
> >   kbuild: simplify argument loop in scripts/config
> >   kbuild: add generic --set-str option to scripts/config
> 
> Andi - do I have your ack on this serie?

Reluctantly -- most bits are ok, but the awk change seems quite overcomplicated
and I don't like it particularly.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
