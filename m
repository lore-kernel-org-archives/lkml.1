Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYJHJeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYJHJeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYJHJeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:34:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:21706 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbYJHJeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X5ioPUp5il4wk3IyGZ0NmM5NZbclioFcH46nR9nyZK0sIjulWR8VK3iznQkxUgmRoV
         YItdK4Hn7iboDBrAoJOR9pY5BCPfUrPYmD8v6Rf2d8dNaZUcaIHnLT+E41LBmrZ6CWF7
         bNZej1aYTf1dhMpOZNTrinmHuZRdQDOTnPw68=
Subject: Re: FRV/ARM unaligned access question
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081008091055.GB19322@flint.arm.linux.org.uk>
References: <1223450773.8195.80.camel@brick>
	 <20081008073519.GA19322@flint.arm.linux.org.uk>
	 <1223451379.8195.88.camel@brick>
	 <20081008091055.GB19322@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 02:34:07 -0700
Message-Id: <1223458447.8195.93.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 10:10 +0100, Russell King wrote:
> On Wed, Oct 08, 2008 at 12:36:19AM -0700, Harvey Harrison wrote:
> > On Wed, 2008-10-08 at 08:35 +0100, Russell King wrote:
> > > On Wed, Oct 08, 2008 at 12:26:13AM -0700, Harvey Harrison wrote:
> > > > I noticed that frv/arm are the only two arches that currently use open-coded
> > > > byteshifting routines for both the cpu endianness and the other endianness
> > > > whereas just about all the other arches use a packed-struct version for the
> > > > cpu-endian and then the byteshifting versions (lifted from arm) for the other
> > > > endianness.
> > > 
> > > I'm sorry, I think you're mistaken.  I've looked at x86, m68k and
> > > parisc, and they all use assembly for their swab functions in
> > > asm/byteorder.h.
> > > 
> > 
> > Sorry, not talking about byteorder at the moment, talking about
> > unaligned.h.
> 
> At the moment, I've no idea what effect it'll have.  I'd need to run
> some tests to discover what the effect will be.  Not sure when I'll
> get around to that.
> 
> If someone else can be found to evaluate what the effect would be...
> 

I don't have hardware to test with, but I'll do some cross-compiles to
investigate a bit.  I was just curious if there was any known issues on
arm, or a specific arm compiler that made you choose the implementation
you did.

Cheers,

Harvey

