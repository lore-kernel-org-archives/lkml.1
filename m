Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYAIOYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYAIOYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYAIOYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:24:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbYAIOYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:24:07 -0500
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Date: Wed, 9 Jan 2008 15:26:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <20080109002803.GA3732@elte.hu> <20080109021124.GH25945@bingen.suse.de> <20080109104711.GA14041@elte.hu>
In-Reply-To: <20080109104711.GA14041@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091526.12040.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 11:47:11 Ingo Molnar wrote:
> * Andi Kleen <ak@suse.de> wrote:
> > There's one Jan pointed out: iounmap does not subtract the guard page
> > size so it ends up resetting one page too much. That is probably what
> > causes your problem. But again you should be passing in G in the first
> > place.
> >
> > -Andi
> >
> > Here was Jan's patch; it incidently fixes the G problem too
>
> thanks, applied. I changed:

FWIW Without the reference counting fixes in the cpa series that will
likely cause leaked small page mappings at boot because the reference
counting cannot deal with it.

-Andi
