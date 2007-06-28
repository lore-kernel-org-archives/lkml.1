Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbXF1HGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbXF1HGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXF1HGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:06:13 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:49201 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbXF1HGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:06:13 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] CodingStyle: Add information about trailing whitespace.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 28 Jun 2007 15:08:03 +0800
Message-ID: <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
In-Reply-To: <46835C16.9020700@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] CodingStyle: Add information about trailing whitespace.
Thread-Index: Ace5UgnZXf3QbkGDROeFfgCN16ODbAAAKfdA
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Josh Triplett" <josh@kernel.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "dave young" <hidave.darkstar@gmail.com>,
       "Chris Shoemaker" <c.shoemaker@cox.net>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Josh Triplett
> Sent: Thursday, June 28, 2007 2:59 PM
> To: Jan Engelhardt
> Cc: dave young; Chris Shoemaker; Josh Triplett;
linux-kernel@vger.kernel.org;
> akpm@linux-foundation.org
> Subject: Re: [PATCH] CodingStyle: Add information about trailing
whitespace.
> 
> Jan Engelhardt wrote:
> > On Jun 28 2007 06:29, dave young wrote:
> >> IMHO, another  cause of trailing whitespace is human error, for
> >> example long lines breaking will easy to cause the first line with
one
> >> traling whitespace (original space between the last two words).
> >
> > Most common errors (to me) are:
> >
> >  - hit return+tab too quickly that it interchanges, hence producing
> >    the unwanted \t\n
> >  - hit return+return to start a new paragraph of code;
> >    the intermediate line remains indented if autoindent is on.
> 
> Interestingly, emacs gets that case right: when you hit enter it
places the
> cursor at the properly indented insertion point, but if you leave the
line
> without typing anything it does not leave the indentation.  I thought
I
> remembered vim doing the same thing, but I just tested and it appears
not.  It
> seems to avoid leaving subsequent lines indented, but not the first
one.

No, vim works just fine here without leaving any indentation.  Maybe the
version of vim or the options matter.

- Leo
