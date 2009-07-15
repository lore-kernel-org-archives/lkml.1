Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZGOPoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZGOPoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZGOPop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:44:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59028 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbZGOPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=ToPTNkB7NSwnGgxmkQItUd3NUPXJmzYGC+ZzVOm/BMcjueHqRavVyoTEtjoRHetYMz
         sqP6f6KPdptOw3IKsjCEccCrOUpKA27hzo8sn44CgBouxrdRznKQti47QmaLbo7eV8nb
         c6WJdsj5gPWRRBNoyQDDhDXeqApiklohB1SUE=
Date: Wed, 15 Jul 2009 17:44:37 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       linux-kernel@vger.kernel.org, andi@lisas.de
Subject: Re: [PATCH] Acerhdf: fix fan control for AOA150 model
Message-ID: <20090715154437.GA11747@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Peter Feuerer <peter@piie.net>,
	Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
	linux-kernel@vger.kernel.org, andi@lisas.de
References: <20090712232104.4f2fbf46.peter@piie.net>
 <20090713160614.521c932a.akpm@linux-foundation.org>
 <cone.1247555228.809275.18208.1000@arca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cone.1247555228.809275.18208.1000@arca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 09:07:08AM +0200, Peter Feuerer wrote:
> Hi Andrew,
> 
> Andrew Morton writes:
> 
> >On Sun, 12 Jul 2009 23:21:04 +0200
> >Peter Feuerer <peter@piie.net> wrote:
> …
> >>Changed:
> >> o Applied Borislav Petkov's patch (convert the fancmd[] array
> >>to a real    struct thus disambiguating command handling and
> >>making code more readable.)
> >> o Added BIOS product to BIOS table as AOA110 and AOA150 have
> >>   different register values
> >> o Added force_product parameter to allow forcing different
> >>   product
> >> o fixed linker warning caused by "acerhdf_drv" not being named
> >>   "acerhdf_driver"
> >>
> >>Signed-off-by: Peter Feuerer <peter@piie.net>
> >
> >It looks like this work should have been presented as four separate patches.
> 
> I'm not that familiar with git in general and sending patches yet.
> How do you do this in an effective way? Diffing all changes via git
> and then splitting up the "all-in-one-patch" to four smaller patches
> manually?

Here's a very fine reading how to do stuff with git:

http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
 
> >Inclusion of Borislav's Signed-off-by: would be appropriate.
> 
> I wasn't sure whether I'm allowed to send the patch with his
> signed-off, as there were other things in the patch, he didn't
> review. But next time I'll send such a patch splitted up and then
> it's clear.

Normally, one S-O-B in a multi-S-O-B patch refers only to the bits that
single author has changed. In case you want to say that only a subset of
the changes are originating from one person, you can mention that in the
commit message, something along the lines of

"... patch based loosely on work by... " or similar.

By the way, your patch works fine here:

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
