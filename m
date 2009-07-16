Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZGPB41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZGPB41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbZGPB40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:56:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:52964 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939AbZGPB4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:56:25 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@tiscali.co.uk>
In-Reply-To: <1247708177.9851.4.camel@concordia>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <1247708177.9851.4.camel@concordia>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 11:56:05 +1000
Message-Id: <1247709365.27937.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 11:36 +1000, Michael Ellerman wrote:
> 
> Builds for the important architectures, powerpc, ia64, arm, sparc,
> sparc64, oh and x86:
> 
> http://kisskb.ellerman.id.au/kisskb/head/1976/
> 
> (based on your test branch 34f25476)

Note for all lurkers: the fails in there are unrelated to the patch
(mostly warnings triggering our new Werror and probably mostly fixed
upstream already).

Cheers,
Ben.

