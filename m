Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbZAGVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbZAGVQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZAGVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:16:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39369 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbZAGVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:16:28 -0500
Date: Wed, 7 Jan 2009 22:30:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/3] KBUILD: Add a "bin" symlink for the scripts directory too
Message-ID: <20090107213032.GM496@one.firstfloor.org>
References: <20090103321.351399938@firstfloor.org> <20090103022143.6D0803E6650@basil.firstfloor.org> <20090107202712.GI4647@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107202712.GI4647@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 09:27:12PM +0100, Sam Ravnborg wrote:
> On Sat, Jan 03, 2009 at 03:21:43AM +0100, Andi Kleen wrote:
> > 
> > Several of the scripts in "scripts" are useful to operate on
> > files in a separate objdir. Instead of always manually typing
> > the path to the source dir create a convenient symlink to
> > the source dir's script directory in the objdir too.
> > 
> > I named it bin because scripts was already used for the object
> > files of scripts.
> 
> So you suggest we in the O=... case should have
> a bin symlink to save you typing "source/sc<tab>

Yes.

> 
> That does not justify another symlink in the output
> directory.

Why not? They don't cost anything, do they? And
convenience matters.

-Andi

-- 
ak@linux.intel.com
