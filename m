Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZDIAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZDIAVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDIAVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:21:09 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43319
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZDIAVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:21:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cross-compilers
Date: Wed, 8 Apr 2009 19:20:58 -0500
User-Agent: KMail/1.9.10
Cc: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org>
In-Reply-To: <20090407225457.86f8a458.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081921.00647.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 00:54:57 Andrew Morton wrote:
> On Tue, 7 Apr 2009 23:46:12 -0600 Alex Chiang <achiang@hp.com> wrote:
> > * Robin Holt <holt@sgi.com>:
> > > Don't know if this answers your problem, but I use the tools from
> > > emdebian and they do not suffer from the problems you list below.
> >
> > Wow, this seems _much_ simpler. Once you get the toolchain
> > installed, all you have to do is set ARCH and CROSS_COMPILE
> > appropriately?
> >
> > I guess the question remains for Andrew. Since I pretty much did
> > all the work needed to update his cross-compiler repo, is there
> > still value in it?
>
> We would benefit very much from having someone who actually maintains a
> suite of cross-compilers for kernel developers.

I already maintain cross compilers for my own use and the uClibc.org guys, 
along with little root filesystems and system images bootable under qemu:

  http://uclibc.org/downloads/binaries

We're about to start doing nightly builds based on uClibc snapshots, I could 
easily get our server to do similar nightly builds based on the git version 
kernel headers and upload 'em to 
http://kernel.org/pub/linux/kernel/people/landley/ if there's any interest...

Rob
-- 
GPLv3 is to GPLv2 what Attack of the Clones is to The Empire Strikes Back.
