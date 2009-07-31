Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZGaEE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZGaEE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 00:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZGaEEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 00:04:55 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:60966 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbZGaEEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 00:04:52 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907310404.n6V44Qn0005781@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: consolidated fixes (NULL pointer checks, [un]registration fixes, etc)
To: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz)
Date: Fri, 31 Jul 2009 13:34:26 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com (Dan Carpenter), corbet@lwn.net, eteo@redhat.com,
       julia@diku.dk (Julia Lawall)
In-Reply-To: <200907301408.10864.bzolnier@gmail.com> from "Bartlomiej Zolnierkiewicz" at Jul 30, 2009 02:08:10 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

> > This patch consolidates the two patches posted by Bartlomiej Zolnierkiewicz
> > and the NULL pointer patch which came out of a discussion with Julia Lawall.
> > Some additional NULL pointer check tidy-ups have also been done.
> > 
> > To summarise:
> 
> I think that for the increased readability and to preserve proper credits it
> would be better to keep separate patches (updating the driver version can be
> as well handled in an incremental patch).

Ok, leave it with me and I'll re-split along these lines.

> I would also strongly insist on removing the following needless NULL pointer
> checks introduced by this version.  They may hide real bugs in the ACPI driver
> code (which should make sure that we always have valid 'device' in the ACPI
> driver methods and that it doesn't go away while the method executes) or in
> the fujitsu-laptop itself (which has to always provide valid 'fujitsu_hotkey',
> 'fujitsu' and 'input' pointers and not free them while there are still some
> users left).

I'll take another look at these.  What I was concerned about was whether the
hotkey pointer in particular was valid in all cases (since some of the
relevant laptops don't in fact have hotkeys) - and I was very short of time
yesterday.  I've had a very quick look through the code just now and it
seems that this may not be a problem after all.  In any case I'll confirm
this over the next day or so and redo/reisssue the patches accordingly.

Regards
  jonathan
