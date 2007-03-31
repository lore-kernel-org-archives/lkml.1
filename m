Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXCaCgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXCaCgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933404AbXCaCgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:36:08 -0400
Received: from mx1.suse.de ([195.135.220.2]:60481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbXCaCgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:36:07 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 4/6] Convert PDA into the percpu section
Date: Sat, 31 Mar 2007 04:35:58 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20070331020042.003398870@goop.org> <20070331020055.075978807@goop.org>
In-Reply-To: <20070331020055.075978807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703310435.59298.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 04:00, Jeremy Fitzhardinge wrote:
> Currently x86 (similar to x84-64) has a special per-cpu structure
> called "i386_pda" which can be easily and efficiently referenced via
> the %fs register.  An ELF section is more flexible than a structure,
> allowing any piece of code to use this area.  Indeed, such a section
> already exists: the per-cpu area.

Hmm, I'm a little reluctant. This moves i386 more away from x86-64
again. If we ever merge them it would mean more work. Do you really need it?



-Andi
