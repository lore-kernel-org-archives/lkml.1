Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYHKWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYHKWTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHKWTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:19:41 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35856 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYHKWTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:19:40 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] PNP: make the resource type an unsigned long
Date: Mon, 11 Aug 2008 16:18:02 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <489BEA31.3040101@keyaccess.nl> <200808111559.01575.bjorn.helgaas@hp.com> <48A0B852.4070107@zytor.com>
In-Reply-To: <48A0B852.4070107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111618.02765.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008 04:08:18 pm H. Peter Anvin wrote:
> Bjorn Helgaas wrote:
> > 
> > I see hpa's point that it makes no functional difference, but I do
> > think it's worthwhile to make the types match.  I don't want to
> > debug the problem that happens when somebody adds an IORESOURCE_*
> > flag in the upper bits.
> 
> Then half the platforms break anyway.
> 
> We should change this to an explicit type.

Are you suggesting a change to the "unsigned long flags" in struct
resource, or a different change to pnp_resource_type()?

The struct resource change sounds reasonable, but I think neither
Rene nor I want to sign up to do that right now.

Whatever we have in struct resource, I think it makes sense to use
the same type everywhere we reference the "flags" element.  I think
you're saying "it doesn't matter in this case that we use different
types."  But I, as a code reader, would rather not have to spend the
mental energy to convince myself that you're right.

Bjorn
