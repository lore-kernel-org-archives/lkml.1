Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZGaD5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZGaD5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 23:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZGaD5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 23:57:46 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:48230 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZGaD5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 23:57:45 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907310357.n6V3vFSr005759@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
To: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz)
Date: Fri, 31 Jul 2009 13:27:15 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com (Dan Carpenter), corbet@lwn.net, eteo@redhat.com,
       julia@diku.dk (Julia Lawall)
In-Reply-To: <200907301312.48132.bzolnier@gmail.com> from "Bartlomiej Zolnierkiewicz" at Jul 30, 2009 01:12:47 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
> > > 
> > > This takes care of the following entries from Dan's list:
> > > 
> > > drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning: variable derefenced before check 'fujitsu'
> > > drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning: variable derefenced before check 'fujitsu'
> > 
> > I'd rather keep the test for a non-null fujitsu in there, but obviously it's
> > kind of pointless doing it after the first dereference.  Since this fixup
> > overlaps with the one previously discussed with Julia I've taken the liberty
> 
> They are on top of Julia's patch (sorry I forgot to mention it)..

Ah, right.  I was trying to work out where it fitted (that was probably the
one preceeding patch I *didn't* end up trying).

Regards
  jonathan
