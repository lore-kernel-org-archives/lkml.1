Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbXLOWUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbXLOWUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXLOWUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:20:45 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:57952 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbXLOWUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:20:44 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH][RFC] dynamic pipe resizing
Date: Sat, 15 Dec 2007 23:23:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
References: <20070824085221.GA23758@kernel.dk> <Pine.LNX.4.64.0712151336230.22877@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712151336230.22877@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712152323.07218.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 December 2007, Jan Engelhardt wrote:
> On Aug 24 2007 10:52, Jens Axboe wrote:
> >Subject: [PATCH][RFC] dynamic pipe resizing
> >Like with my original splice patches from 2005, I used fcntl()
> >F_GETPIPE_SZ and F_SETPIPE_SZ to change the size of the pipe. I'm not
> >particularly fond of that interface, so suggestions on how to improve it
> >would be appreciated. Even if fcntl() should be the preferred approach,
> >I think it would be better to pass in a byte based value instead of a
> >number of pages.
> >
> Could this patch still make it in?
> Yes, I think its set() and get() parts should use bytes and convert 
> to/from pages.
> 
> Perhaps just round up, and mention the rounding in the manpage, so that 
> noone gets a shock when the pipe is not exactly as small as requested.

Yes, but document only that it is rounding and make the unit arbitrary.
That reduces the ABI requirements.


Best Regards

Ingo Oeser
