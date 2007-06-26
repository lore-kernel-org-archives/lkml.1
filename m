Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXFZOso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXFZOso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXFZOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:48:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45305
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXFZOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:48:37 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix headers_install for x86-64 (now with less whitespace damage!)
Date: Tue, 26 Jun 2007 10:48:41 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200706260912.37441.rob@landley.net> <1182866629.8896.37.camel@pmac.infradead.org>
In-Reply-To: <1182866629.8896.37.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261048.41738.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 10:03:49 David Woodhouse wrote:
> On Tue, 2007-06-26 at 09:12 -0400, Rob Landley wrote:
> > Signed-off-by: Rob Landley <rob@landley.net>
> >
> >  A bug in headers_install for ARCH=x86_64 yields an asm/ directory full
> > of files all of which are using the same #ifdef guard, "__ASM_STUB_" with
> > no postfix. So the second and later asm files #included in the same C
> > file (often through standard headers like ioctl.h) yields no symbols.
>
> Interesting. It works here with bash 3.2 -- I thought it was the _first_ 
> shell which expanded $FNAME and $STUBDEF inside the parentheses. Which
> shell are you using?

Stock Ubuntu 7.04 comes with /bin/sh pointing to the Dumb-Ass SHell.  (Motto: 
If it's not explicitly mentioned in posix, and we accidentally support it, 
let us know so we can remove it!)

> Is it sufficient just to add the missing semicolon after FNAME=...?

Huh.  Apparently, yes it is.  (I thought I'd tried that and it hadn't worked, 
but I just tried it again and it worked, so ok.  It's before noon, don't 
expect accuracy from me yet today...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
