Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbXIEL1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbXIEL1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 07:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbXIEL1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 07:27:13 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:58051 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXIEL1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 07:27:13 -0400
X-Greylist: delayed 1305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 07:27:13 EDT
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robert Richter <robert.richter@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
References: <20070903081736.288288000@amd.com>
	<20070903081736.588599000@amd.com>
	<20070903013157.72c94891@laptopd505.fenrus.org>
	<20070903091718.GB22144@alberich.amd.com>
	<20070903043319.7573875b@laptopd505.fenrus.org>
	<20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
	<20070905084427.GE6409@erda.amd.com> <46DE80F0.4000706@zytor.com>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Wed, 05 Sep 2007 13:05:25 +0200
In-Reply-To: <46DE80F0.4000706@zytor.com> (H. Peter Anvin's message of "Wed\, 05 Sep 2007 11\:12\:00 +0100")
Message-ID: <kjmd4wxz822.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
> You're missing the point.   How will the PCI bus transactions be
> different when using MMCONFIG versus your extended CF8 version?

Conceivably this is useful if the IO hub does not support MMCONFIG
accesses.  The AMD 8111 does not, as far as I can see.  At least I
have an Opteron system where MMCONFIG is not supported, and I assume
it's because the 8111 doesn't provide it.  I don't know if this is
going to be a realistic scenario for Barcelona systems.

-- 
								Arne.
