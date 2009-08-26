Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbZHZM0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbZHZM0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932624AbZHZM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:26:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56594 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbZHZM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:26:44 -0400
Date: Wed, 26 Aug 2009 13:26:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Will Brown <dr.hfuhruhurr@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Epoll frequently fails to notify connects at connect
	bursts
Message-ID: <20090826122641.GA29299@sirena.org.uk>
References: <8a1bd2320908251748u324ae5e6g7015069180253db3@mail.gmail.com> <alpine.DEB.2.00.0908251812450.18518@makko.or.mcafeemobile.com> <alpine.DEB.2.00.0908251823470.18518@makko.or.mcafeemobile.com> <8a1bd2320908260215w23d1f426x33f90e38ccc3fe2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a1bd2320908260215w23d1f426x33f90e38ccc3fe2c@mail.gmail.com>
X-Cookie: Them as has, gets.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 11:15:10AM +0200, Will Brown wrote:
> On Wed, Aug 26, 2009 at 3:24 AM, Davide Libenzi<davidel@xmailserver.org> wrote:

> >> Multiple quasi-simultaneous events for the same fd are merged. This is why
> >> on POLLIN on accepting sockets you want to do something like:

> Aha! Thank you immensely Davide. It cost me one week of frustration already.

> 1. Where should I have picked up this gem of essential information? I
> haven't seen it in the man-pages for either 'epoll' or 'accept'.

It should be covered in the "Level-Triggered and Edge-Triggered" section
of the epoll() manual page - the particular case of accept() isn't
covered but the general idea is the same.
