Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZCKPiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZCKPiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZCKPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:37:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807AbZCKPhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:37:55 -0400
Date: Wed, 11 Mar 2009 08:36:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <1236769025.7086.46.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0903110835020.32478@localhost.localdomain>
References: <1236729444.7086.24.camel@pasglop>  <alpine.LRH.2.00.0903111028480.1040@vixen.sonytel.be> <1236769025.7086.46.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Mar 2009, Benjamin Herrenschmidt wrote:
> 
> I'd like to have Andrew or Linus opinion on doing this driver swap that
> late in the process.

Quite franklly, no. 

If it was a totally _new_ driver, there's no chance of regression, which 
is why we allow those drivers.

But switching an old one for a new one does not match that pattern. We can 
clearly get regressions. As such, we don't do it late in the -rc series.

		Linus
