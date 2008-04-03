Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYDCPKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYDCPKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYDCPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:10:29 -0400
Received: from saeurebad.de ([85.214.36.134]:58047 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056AbYDCPK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:10:28 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [RFC 10/22] m68k: Use generic show_mem()
References: <12071688283927-git-send-email-hannes@saeurebad.de>
	<1207168941186-git-send-email-hannes@saeurebad.de>
	<Pine.LNX.4.64.0804030939320.9848@anakin>
	<87myobp02g.fsf@saeurebad.de>
	<Pine.LNX.4.64.0804031538150.11898@anakin>
Date: Thu, 03 Apr 2008 17:10:21 +0200
In-Reply-To: <Pine.LNX.4.64.0804031538150.11898@anakin> (Geert Uytterhoeven's
	message of "Thu, 3 Apr 2008 15:39:16 +0200 (CEST)")
Message-ID: <87wsnfnfdu.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> So I suggest to add an additional (first) step to the consolidation: remove all
> duplicates.

I shall do that.  Problem is, I had a patch-series removing only parts
of the duplication (shame on me) and not all of these patches are yet in
the subsystem trees and still partially in -mm.  None of them have hit
mainline yet.  Suggestions?

The earlier patch-series was called `remove redundant output from
show_mem()'.

Sorry for the wasted time.  These cleanups already took more energy than
they are worth it, I guess... :/

	Hannes
