Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXFITgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXFITgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXFITgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:36:49 -0400
Received: from pop-knobcone.atl.sa.earthlink.net ([207.69.195.64]:53087 "EHLO
	pop-knobcone.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbXFITgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:36:48 -0400
Content-Disposition: inline
From: Rich Chase <rac47.02@engalumni.colostate.edu>
Organization: Independent Thinkers R Us
To: linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Date: Sat, 9 Jun 2007 12:34:59 -0400
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706091234.59231.rac47.02@engalumni.colostate.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

> >In your case the kernel was not build.
> >And to build modpost you need to execute "make
> > modules" from the kernel top-level directory.
>
> "make scripts" ?

Wouldn't this do the same as going into the ".scripts/"
directory and doing make?

My problem is that the script 'modpost' requires the
include file, elfconfig.h, because it is included in
modpost.c.

> Most likely it is one of the worse Makefile...

Entirely possible. Maybe the module shouldn't need the
modpost script anymore? That would explain why my
kernel built and runs fine without successful compile
of the script. But then why is the source for the
script still in the kernel tree?

Thanks,
Rich

-------------------------------------------------------
