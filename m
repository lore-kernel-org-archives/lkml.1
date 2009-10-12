Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbZJLSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbZJLSte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbZJLStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:49:33 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:41409 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbZJLStc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gU79wJ8+0SBgCvPPZnruzgGpIm4qdVBhY9PvBPvRyAUfRG5uv+om1fRwEdQg175J7D
         LUKqlm+ohVOn7HI8mnqDxpxhEYleIHGtevA9ONjqakg/2/I1r6QPPLLwbRf6fgwFYD4n
         WFiElL1bVfAww3TEfLxRsuZNsYVMm2aldTomE=
MIME-Version: 1.0
In-Reply-To: <r-4Wjt4coy.A.TPD.dal0KB@chimera>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <r-4Wjt4coy.A.TPD.dal0KB@chimera>
Date: Mon, 12 Oct 2009 20:48:54 +0200
Message-ID: <b637ec0b0910121148g34f46481n1d5d4edb67b0ac55@mail.gmail.com>
Subject: Re: [Bug #14372] Wireless not working after suspend-resume
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still present with -rc4.

Error is:

[  690.547660] wlan0: direct probe to AP 00:11:95:09:2c:e0 (try 1)
[  690.550064] wlan0: direct probe responded
[  690.550074] wlan0: authenticate with AP 00:11:95:09:2c:e0 (try 1)
[  690.551629] wlan0: authenticated
[  690.551663] wlan0: associate with AP 00:11:95:09:2c:e0 (try 1)
[  690.553289] wlan0: RX AssocResp from 00:11:95:09:2c:e0 (capab=0x451
status=12 aid=1)
[  690.553298] wlan0: AP denied association (code=12)

rfkill-ing the device off and then on fixes the problem.

Fabio




On Mon, Oct 12, 2009 at 12:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14372
> Subject         : Wireless not working after suspend-resume
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-10-03 15:36 (9 days old)
> References      : http://lkml.org/lkml/2009/10/3/91
>
>
>
