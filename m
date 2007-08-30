Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXH3SMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXH3SMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXH3SMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:12:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39640 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932157AbXH3SMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:12:36 -0400
Date: Thu, 30 Aug 2007 11:12:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jan Dittmer <jdi@l4x.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
In-Reply-To: <46D66D49.20300@l4x.org>
Message-ID: <Pine.LNX.4.64.0708301112030.7975@schroedinger.engr.sgi.com>
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org>
 <20070829234734.GA26410@stusta.de> <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com>
 <46D66D49.20300@l4x.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Jan Dittmer wrote:

> Christoph Lameter wrote:
> > On Thu, 30 Aug 2007, Adrian Bunk wrote:
> > 
> > > Christoph, is your fix in -mm suitable for 2.6.23, or how else should this
> > > regression be fixed for 2.6.23?
> > 
> > Looks like this is just alpha and a certain particular compiler version? 
> 
> binutils 2.15.95, gcc 3.3.6 and I could update to 4.0.4 or something
> more recent I guess. And yes, it's only alpha.
> 
> Of which file do you want the objdump?

The one where the link fails. Dump the code around the unresolved symbol.


