Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZLEUeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZLEUeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZLEUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:34:09 -0500
Received: from kroah.org ([198.145.64.141]:33904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbZLEUeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:34:08 -0500
Date: Sat, 5 Dec 2009 11:58:52 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] x86: Remove STACKPROTECTOR_ALL
Message-ID: <20091205195852.GC21172@kroah.com>
References: <200911021859.nA2Ix4cB023712@hera.kernel.org>
 <4AF9E7D4.9080309@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9E7D4.9080309@mandriva.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 12:23:16AM +0200, Thomas Backlund wrote:
> I think this one should go to 2.6.31.x too ...
> 
> > Gitweb:     http://git.kernel.org/linus/14a3f40aafacde1dfd6912327ae14df4baf10304
> > Commit:     14a3f40aafacde1dfd6912327ae14df4baf10304
> > Parent:     02dd0a0613e0d84c7dd8315e3fe6204d005b7c79
> > Author:     Arjan van de Ven <arjan@infradead.org>
> > AuthorDate: Fri Oct 23 07:31:01 2009 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri Oct 23 16:35:23 2009 +0200
> > 
> >     x86: Remove STACKPROTECTOR_ALL
> >     
> >     STACKPROTECTOR_ALL has a really high overhead (runtime and stack
> >     footprint) and is not really worth it protection wise (the
> >     normal STACKPROTECTOR is in effect for all functions with
> >     buffers already), so lets just remove the option entirely.
> >     
> >     Reported-by: Dave Jones <davej@redhat.com>
> >     Reported-by: Chuck Ebbert <cebbert@redhat.com>
> >     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> >     Cc: Eric Sandeen <sandeen@redhat.com>
> >     LKML-Reference: <20091023073101.3dce4ebb@infradead.org>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>

It doesn't really "fix" anything, so I'd prefer not too.

thanks,

greg k-h
