Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYA3FEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYA3FEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYA3FEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:04:34 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:58685 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYA3FEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:04:33 -0500
Date: Wed, 30 Jan 2008 05:04:24 +0000
From: Jon Masters <jonathan@jonmasters.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130050424.GA22444@dallas.jonmasters.org>
References: <1201641765.18773.35.camel@dv> <1201652420.2271.91.camel@perihelion> <1201657701.24898.14.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201657701.24898.14.camel@dv>
User-Agent: Mutt/1.5.11
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jcm@dallas.jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 08:48:21PM -0500, Pavel Roskin wrote:
> On Tue, 2008-01-29 at 19:20 -0500, Jon Masters wrote:
> 
> > Yes it is. But I thought the existing code was intending to taint the
> > kernel (that's what it does), so it would really help to identify why it
> > tainted the kernel, by calling add_taint_module instead of add_taint. I
> > didn't put the existing match in there...don't shoot the messenger :)
> 
> So, it's the same thing as in year 2006.  Good intentions, unexpected
> side effects, and a long discussion.

I wouldn't quite say that. I wasn't going to comment, but...personally,
I actually disagree with the assertions that ndiswrapper isn't causing
proprietary code to link against GPL functions in the kernel (how is
an NDIS implementation any different than a shim layer provided to
load a graphics driver?), but I wasn't trying to make that point.

Rusty - shall we just move the taint to post symbol resolution?

Jon.
