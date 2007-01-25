Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXAYCR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXAYCR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXAYCR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:17:26 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45918 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbXAYCRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:17:25 -0500
Subject: Re: In-tree version of new FireWire drivers available
From: David Moore <dcm@MIT.EDU>
To: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>
Cc: Pieter Palmers <pieterp@joow.be>, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <59ad55d30701241630o6995d115je8e37a1d1eb6252f@mail.gmail.com>
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
	 <45B75FDB.1000004@joow.be>
	 <59ad55d30701241245l7671af23w3e19a83621c6fb51@mail.gmail.com>
	 <45B7CD78.8010907@mit.edu>
	 <59ad55d30701241630o6995d115je8e37a1d1eb6252f@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 24 Jan 2007 21:17:00 -0500
Message-Id: <1169691420.16086.4.camel@eastgate-five-sixty-four.mit.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 19:30 -0500, Kristian Høgsberg wrote:

> The problem isn't packets that are too big, the problem is we can get
> unexpected / too many empty packets, which will then cause the DMA
> engine to move on to the next descriptor before the payload buffer has
> been completely filled. 

I was under the impression that for an empty packet, the descriptor
wouldn't fire at all.  Is that not correct?

-David

