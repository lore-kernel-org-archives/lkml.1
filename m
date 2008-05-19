Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbYESUeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbYESUeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYESUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:34:28 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:46635 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYESUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q1wQAHuX7opkm9T+1haX5m1pqnBbUn1frWQtzD2YjfYIPQ7lTfaepLtE+viM9bB+iDcgt81Kn5ncoFDPngbNRAAtMZNyIYIfmv8kurUwQiVrJ1lRvMIaySO/zOH4nYGfeBV/JSAiRl4UXn1hVS8oEk0ym9z6xYOe0g2YyDUlutg=
Message-ID: <df47b87a0805191334j5768cdb6i977ea6dfc7cd9b63@mail.gmail.com>
Date: Mon, 19 May 2008 23:34:26 +0300
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc2-git5: Reported regressions from 2.6.25
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 2:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.25, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.

There is a patch available for the regression below. I have tested it
and it has fixed my issue. Thank you Miklos Szeredi! Patch available
at: http://marc.info/?l=linux-kernel&m=121122564714638&w=2


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10742
> Subject         : BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
> Submitter       : Ioan Ionita <opslynx@gmail.com>
> Date            : 2008-05-17 20:37 (2 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121105669717787&amp;w=4
