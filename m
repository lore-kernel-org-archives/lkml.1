Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbZHCPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbZHCPXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZHCPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:23:12 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:52692 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbZHCPXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FxHDt5KYF2fLVMtUw4vLKDEs27Q5EfbDlxRuDGnlBGe1jY5V8dyy1nxxy+09PopD3Q
         ua47QRNMO8H1526OflqdyvusKPnAh+3oKTiOXQ8lf1/zHvDnqmGl/Co4xnew8naOIzSI
         if3DzHOknoLkRRhfeVoDMWMOEbHmlNEUSb5KM=
MIME-Version: 1.0
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Aug 2009 08:16:39 -0700
Message-ID: <43e72e890908030816n187cda20keda2c9ba1b15a89c@mail.gmail.com>
Subject: Re: 2.6.31-rc5: Reported regressions 2.6.29 -> 2.6.30
To: "Rafael J. Wysocki" <rjw@sisk.pl>, rootkit85@yahoo.it
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the wireless ones:

On Sun, Aug 2, 2009 at 12:06 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:

> Unresolved regressions
> ----------------------
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13898
> Subject         : Intel 3945ABG - problems on 2.6.30.X
> Submitter       : dienet <dienet@poczta.fm>
> Date            : 2009-07-31 15:17 (3 days old)
> References      : http://marc.info/?l=linux-kernel&m=124905346729959&w=4


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13638
> Subject         : rt2870 driver is broken for (some) cards
> Submitter       : jakob gruber <jakob.gruber@kabelnet.at>
> Date            : 2009-06-27 17:33 (37 days old)



> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13581
> Subject         : ath9k doesn't work with newer kernels
> Submitter       : Matteo <rootkit85@yahoo.it>
> Date            : 2009-06-19 12:04 (45 days old)

Issue looks more like a the user has rfkill enabled rather than a
driver issue. Waiting on user feedback since 2009-07-27.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject         : rt2x00: slow wifi with correct basic rate bitmap
> Submitter       : Alejandro Riveira <ariveira@gmail.com>
> Date            : 2009-05-22 13:32 (73 days old)



> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13337
> Subject         : [post 2.6.29 regression] hang during suspend of b44/b43 modules
> Submitter       : Tomas Janousek <tomi@nomi.cz>
> Date            : 2009-05-18 10:59 (77 days old)
> Handled-By      : Johannes Berg <johannes@sipsolutions.net>
> Patch           : http://patchwork.kernel.org/patch/37837/


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject         : Page allocation failures with b43 and p54usb
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2009-04-29 21:01 (96 days old)
> References      : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>                  http://lkml.org/lkml/2009/6/7/136
>                  http://lkml.org/lkml/2009/7/26/213
> Handled-By      : Johannes Berg <johannes@sipsolutions.net>
>                  David Rientjes <rientjes@google.com>
> Patch           : http://patchwork.kernel.org/patch/37655/
