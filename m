Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbXE2W0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbXE2W0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXE2W0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:26:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:40226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXE2W0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:26:20 -0400
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
	<p738xb8fjv2.fsf@bingen.suse.de>
	<20070529115324.GB18437@osiris.boeblingen.de.ibm.com>
	<20070529131903.GA5024@one.firstfloor.org>
	<20070529142222.GC18437@osiris.boeblingen.de.ibm.com>
	<20070529145818.GB5024@one.firstfloor.org>
	<20070529164352.GD18437@osiris.boeblingen.de.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 May 2007 01:21:36 +0200
In-Reply-To: <20070529164352.GD18437@osiris.boeblingen.de.ibm.com>
Message-ID: <p73r6ozdxmn.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> writes:
> 
> I'm talking of a specific problem where we just added a panic to the
> zfcp device driver. If that panic ever triggers we know for sure that
> memory corruption happened.
> So I'm just asking to not say in general that panic() in a device driver
> is a bad thing.

Ok there might be exceptions, but in general I still think it's true.
It probably fits the "you must be able to justify any warnings" rule.
I would still like this check to be added.

-Andi
