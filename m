Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXLHIUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXLHIUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXLHITz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:19:55 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:58028 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXLHITz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:19:55 -0500
Subject: Re: [PATCH] depmod: sort output according to modules.order
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1197100997.20786.156.camel@perihelion>
References: <47555AF1.8090304@gmail.com>  <47555C64.8070607@gmail.com>
	 <1197100997.20786.156.camel@perihelion>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 03:19:19 -0500
Message-Id: <1197101959.20786.170.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 03:03 -0500, Jon Masters wrote:
> On Tue, 2007-12-04 at 22:55 +0900, Tejun Heo wrote:
> 
> > Kbuild now generates and installs modules.order along with modules.
> > This patch updates depmod such that it sorts module list according to
> > the file before generating output files.  Modules which aren't on
> > modules.order are put after modules which are ordered by
> > modules.order.
> 
> Thanks. Please CC me in general on these patches :-)
> 
> I was planning to also discuss ordering of module aliases entries, since
> we can have several modules providing the same modalias (this gets even
> worse on "Enterprise Linux" distributions, where we might have third
> party modules providing additional aliases). I guess this ordering is
> probably better than just a numeric sort, which was the original idea.

Actually, this still won't quite solve that problem, because modules not
installed in the kernel itself won't have ordering data supplied. Maybe
I need to do this, *and* then sort modaliases numerically aswell.

Jon.


