Return-Path: <linux-kernel-owner+w=401wt.eu-S936882AbYBVWYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936882AbYBVWYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936568AbYBVWTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:19:49 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43323
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936400AbYBVWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:19:47 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Samuel Masham" <samuel.masham@gmail.com>
Subject: Re: 2.6.24 panics initializing ne2k in mips.
Date: Fri, 22 Feb 2008 16:19:38 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200801280217.38273.rob@landley.net> <20080129111622.GC7237@linux-mips.org> <93564eb70802220617x4de21db0g3291cfc4905c48c5@mail.gmail.com>
In-Reply-To: <93564eb70802220617x4de21db0g3291cfc4905c48c5@mail.gmail.com>
Cc: "Ralf Baechle" <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       linux-mips@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221619.40103.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 08:17:44 you wrote:
> Hi all,
>
> On Tue, Jan 29, 2008 at 8:16 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> > On Mon, Jan 28, 2008 at 02:17:37AM -0600, Rob Landley wrote:
> >  > The 2.6.23 kernel built for mips with the attached .config works fine
> >  > for me under qemu (both big endian and little endian), but a 2.6.24
> >  > mips kernel segfaults initializing the ne2k driver (again when run
> >  > under qemu).
> >  >
> >  > I've traced it to this commit:
> >
> >  Known problem.  The issue only hits when probing IRQs as the NE2000
> > driver does.  This got dropped on the floor in December.
>
> In 2.6.24.2 under qemu (default config as well as my one) its still
> dies at this point.

The patches that fixed it for me were:

http://kernel.org/hg/index.cgi/linux-2.6/rev/85295
http://kernel.org/hg/index.cgi/linux-2.6/rev/85296

Which, as you can see, were already committed to the kernel repository during 
the 2.6.25 merge window.

They don't seem to be in the 2.6.24.2 tarball, though.

I dunno if that's the same problem you're seeing or not...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
