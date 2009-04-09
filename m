Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZDIHzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZDIHzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZDIHzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:55:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48618 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZDIHzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:55:43 -0400
Date: Thu, 9 Apr 2009 09:58:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Mason <chris.mason@oracle.com>, hugh@veritas.com, npiggin@suse.de,
       riel@redhat.com, lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in the VM II
Message-ID: <20090409075805.GG14687@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org> <1239210239.28688.15.camel@think.oraclecorp.com> <20090409072949.GF14687@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409072949.GF14687@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Double checked the try_to_release_page logic. My assumption was that the 
writeback case could never trigger, because during write back the page
should be locked and so it's excluded with the earlier lock_page_nosync().

Is that a correct assumption?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
