Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbYBWH4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbYBWH4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 02:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYBWH4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 02:56:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:55241 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYBWH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 02:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ngBeMTEJsSdZGPxM2Hb3cOtl4iNmEVatiZRUBrr0zsD3n/NpbFJQ2T+014xUnILGCdntID68KEn51QSXCqx4Jzlhzsc+sLks31idsj8Z4DyijmQWX0cLT/enNYTGrbvJPZlQS2b6iSO1awxmXgsrzKlbBKdFvqO/V0mNWw0RwcA=
Message-ID: <93564eb70802222356u261d452aq8a3ad6ccc146d8dc@mail.gmail.com>
Date: Sat, 23 Feb 2008 16:56:42 +0900
From: "Samuel Masham" <samuel.masham@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: 2.6.24 panics initializing ne2k in mips.
Cc: "Ralf Baechle" <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       linux-mips@vger.kernel.org
In-Reply-To: <200802221619.40103.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801280217.38273.rob@landley.net>
	 <20080129111622.GC7237@linux-mips.org>
	 <93564eb70802220617x4de21db0g3291cfc4905c48c5@mail.gmail.com>
	 <200802221619.40103.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 7:19 AM, Rob Landley <rob@landley.net> wrote:
> On Friday 22 February 2008 08:17:44 you wrote:
>  > On Tue, Jan 29, 2008 at 8:16 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
>  > >  Known problem.  The issue only hits when probing IRQs as the NE2000
>  > > driver does.  This got dropped on the floor in December.
>  >
>  > In 2.6.24.2 under qemu (default config as well as my one) its still
>  > dies at this point.
>
>  The patches that fixed it for me were:
>
>  http://kernel.org/hg/index.cgi/linux-2.6/rev/85295
>  http://kernel.org/hg/index.cgi/linux-2.6/rev/85296
>
>  Which, as you can see, were already committed to the kernel repository during
>  the 2.6.25 merge window.
>
>  They don't seem to be in the 2.6.24.2 tarball, though.
>
>  I dunno if that's the same problem you're seeing or not...

Yep that was the problem.

Thanks for the help Rob.

This fixes the 2.6.24 kernel for qemu, I would like to see these
patches put into the stable series.

Is that OK for everyone? if they are in the 2.6.25 tree then we just
send the commit ids to the stable team...

I will send the details to stable on monday if knobody shouts.

Samuel
