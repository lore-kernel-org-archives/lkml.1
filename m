Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXBAIjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXBAIjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422691AbXBAIjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:39:23 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56479 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422689AbXBAIjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:39:23 -0500
Message-ID: <45C1A733.5020002@drzeus.cx>
Date: Thu, 01 Feb 2007 09:39:15 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx>
In-Reply-To: <45B8845E.8070008@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ping!

Pierre Ossman wrote:
> Ok... how about this baby instead. I've replaced the stack allocated
> request structure by one allocated with kmalloc() and reference counted
> using an atomic_t. I couldn't see anything else that was associated to
> the process, so I believe this should suffice.
> 
> (This is just a RFC. Once I get an ok from you I'll put together a more
> proper patch mail)
> 

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
