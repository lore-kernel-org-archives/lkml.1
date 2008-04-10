Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYDJNiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYDJNiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYDJNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:38:39 -0400
Received: from mail.queued.net ([207.210.101.209]:4415 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbYDJNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:38:39 -0400
Date: Thu, 10 Apr 2008 09:40:24 -0400
From: Andres Salomon <dilinger@queued.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: Re: [PATCH 2/3] x86: GEODE: add Virtual Systems Architecture
 detection
Message-ID: <20080410094024.5111e108@ephemeral>
In-Reply-To: <20080410091057.45cbb938@core>
References: <20080409223328.5774d6cf@ephemeral>
	<20080410091057.45cbb938@core>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 09:10:57 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed, 9 Apr 2008 22:33:28 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > This is generic VSA detection.  It's used by OLPC to determine whether or
> > not the BIOS contains VSA, but since other BIOSes are coming out that don't
> > use the VSA (ie, tinybios), it might end up being useful for others.
> 
> NAK - but minor
> 
> This is a check for *VSA2* which is not the same as VSA1 (Cyrix one) and
> for older systems that actually matters as you may have VSA1 or VSA2 and
> they are detected differently.
>

Excellent point.  Can we extend this to check for a VSA1-specific
string, or does VSA1 not have a similar signature?




 
> > +/* VSA magic values */
> 
> These should be VSA2 I think
> 
> > +static inline int geode_has_vsa(void)
> 
> has_vsa2
> 
> 
> Alan (Keeper of the ancient cyrix docs ;))
