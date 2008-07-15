Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYGOQw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYGOQw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYGOQwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:52:19 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60692 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYGOQwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:52:19 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied =?utf-8?q?from=09in-kernel?=, use it in more drivers.
Date: Tue, 15 Jul 2008 18:52:59 +0200
User-Agent: KMail/1.9.9
Cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rene.herman@keyaccess.nl, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <487C0A12.9060906@keyaccess.nl> <200807150823.35628.oliver@neukum.org> <1216132854.27455.247.camel@shinybook.infradead.org>
In-Reply-To: <1216132854.27455.247.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151853.01143.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 15 Juli 2008 16:40:54 schrieb David Woodhouse:
> On Tue, 2008-07-15 at 08:23 +0200, Oliver Neukum wrote:
> > Am Dienstag 15 Juli 2008 08:03:15 schrieb David Woodhouse:
> > > Mostly it follows the documented recommendation, since most of the
> > > touched drivers are USB drivers and you end up re-enumerating and
> > > starting from scratch on resume anyway. And the remainder are so old
> > > that they don't have suspend/resume support anyway. Remember, we're only
> > > really updating the older drivers; newer drivers tend to use
> > > request_firmware() already, and have done for years.
> > 
> > As for USB that was before persistance. It now allows you to even
> > support a loss of power without reprobing, provided
> > 
> > a) the devices does not change IDs
> > b) you have firmware around when reset_resume() is called
> 
> c) the driver in question actually _has_ a reset_resume() method
> 
> The old, unloved drivers which I've touched as part of this patch set
> did not. In general the newer, loved drivers use request_firmware()
> already.
> 

Generally we love all drivers and welcome new additions.
Which did you touch? I lost track.

	Regards
		Oliver

