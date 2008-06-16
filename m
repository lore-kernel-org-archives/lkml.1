Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYFPKDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYFPKDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYFPKD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:03:28 -0400
Received: from saeurebad.de ([85.214.36.134]:52719 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYFPKD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:03:28 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug 10741] bug in `tty: BKL pushdown'?
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.B-E.dKDVIB@albercik>
Date: Mon, 16 Jun 2008 12:03:21 +0200
In-Reply-To: <Jn7irxIunJK.A.B-E.dKDVIB@albercik> (Rafael J. Wysocki's message
	of "Sat, 14 Jun 2008 22:12:02 +0200 (CEST)")
Message-ID: <873andbst2.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
> Subject		: bug in `tty: BKL pushdown'?
> Submitter	: Johannes Weiner <hannes@saeurebad.de>
> Date		: 2008-05-18 2:16 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>

The bug still exists, however, a bisect on another machine with the same
userland leads to different commit
(47f86834bbd4193139d61d659bebf9ab9d691e37 "redo locking of tty->pgrp"),
so it is not all that clear and stable.

I will investigate further but the entry should probably stay for now.

	Hannes
