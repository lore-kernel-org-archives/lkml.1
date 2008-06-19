Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYFSLGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYFSLGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYFSLG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:06:26 -0400
Received: from saeurebad.de ([85.214.36.134]:40479 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592AbYFSLG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:06:26 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10741] bug in `tty: BKL pushdown'?
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.B-E.dKDVIB@albercik> <873andbst2.fsf@saeurebad.de>
	<20080616113313.2f932f8d@lxorguk.ukuu.org.uk>
	<20080616124602.54910afd@lxorguk.ukuu.org.uk>
	<87ve099yyt.fsf@saeurebad.de>
	<20080616192255.312b6be5@lxorguk.ukuu.org.uk>
Date: Thu, 19 Jun 2008 13:06:18 +0200
In-Reply-To: <20080616192255.312b6be5@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 16 Jun 2008 19:22:55 +0100")
Message-ID: <87tzfp4rbp.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> tty->session =
>> tty->pgrp =
>> spin_unlock()
>> 
>> That does not fix it.
>
> Thanks. That rules out the one case I could see that might have pointed
> to a potential bug.

The second bisection was the wrong one, sorry for the confusion.

I tried again (manually) and the result is (still) this:

Everything fine with HEAD at e5238442 "serial_core: Prepare for BKL push
down".
  
Weird behaviour as described with HEAD at 04f378b19 "tty: BKL pushdown".

	Hannes
