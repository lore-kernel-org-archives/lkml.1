Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbXKWJqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbXKWJqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXKWJqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:46:30 -0500
Received: from poesci.dolphinics.no ([81.175.23.36]:48805 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbXKWJq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:46:29 -0500
To: dean gaudet <dean@arctic.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@gentoo.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
	<20071123012911.3266dba6@the-village.bc.nu>
	<alpine.DEB.0.99999.0711222206000.32648@twinlark.arctic.org>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Fri, 23 Nov 2007 10:46:31 +0100
In-Reply-To: <alpine.DEB.0.99999.0711222206000.32648@twinlark.arctic.org> (dean gaudet's message of "Thu\, 22 Nov 2007 22\:18\:28 -0800 \(PST\)")
Message-ID: <kjmpry1mgzs.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet <dean@arctic.org> writes:
> on AMD x86 pre-family 10h the boundary is 8 bytes, and on fam 10h it's 16 
> bytes.  the penalty is a mere 3 cycles if an access crosses the specified 
> boundary.

Worth noting though, is that atomic accesses that cross cache lines on
an Opteron system is going to lock down the Hypertransport fabric for
you during the operation -- which is obviously not so nice.

-- 
								Arne.
