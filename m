Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYDCXqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYDCXqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYDCXqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:46:10 -0400
Received: from saeurebad.de ([85.214.36.134]:57603 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbYDCXqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:46:09 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, kyle@parisc-linux.org, paulus@samba.org,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, jdike@addtoit.com,
       miles@gnu.org, chris@zankel.net, rmk@arm.linux.org.uk,
       tony.luck@intel.com
Subject: Re: [RFC 00/21] Generic show_mem()
References: <12071688283927-git-send-email-hannes@saeurebad.de>
Date: Fri, 04 Apr 2008 01:45:59 +0200
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de> (Johannes
	Weiner's message of "Wed, 2 Apr 2008 22:40:06 +0200")
Message-ID: <87hceimrig.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

most of the feedback I got now was about information displaying that I
allegedly have simply dropped.  This was only true in one case where I
missed the quicklist cache, the other droppings were redundant
information (already displayed in show_free_areas() for example).

Geert suggested that I should boil down show_mem() first for each arch
and then unify it but I would prefer unifying it first and listing
removed redundancy in the changelog of every arch-specific removal. Any
objections on this?

	Hannes
