Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbXE2Lx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbXE2Lx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXE2Lxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:53:51 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:26334 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXE2Lxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:53:50 -0400
Date: Tue, 29 May 2007 13:53:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-ID: <20070529115324.GB18437@osiris.boeblingen.de.ibm.com>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p738xb8fjv2.fsf@bingen.suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 04:23:45AM +0200, Andi Kleen wrote:
> Possible further checks that might make sense:
> - panic() anywhere in drivers/* 

A driver should be allowed to panic. E.g. if it detects that due to a
firmware or driver bug memory corruption happened. IMHO the best thing
to do then is panic.
