Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXLHIEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXLHIEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXLHIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:04:11 -0500
Received: from main.gmane.org ([80.91.229.2]:45549 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752405AbXLHIEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:04:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] depmod: sort output according to modules.order
Date: Sat, 08 Dec 2007 03:03:57 -0500
Organization: World Organi[sz]ation Of Broken Dreams
Message-ID: <1197100997.20786.156.camel@perihelion>
References: <47555AF1.8090304@gmail.com>  <47555C64.8070607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: boston.jonmasters.org
In-Reply-To: <47555C64.8070607@gmail.com>
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-04 at 22:55 +0900, Tejun Heo wrote:

> Kbuild now generates and installs modules.order along with modules.
> This patch updates depmod such that it sorts module list according to
> the file before generating output files.  Modules which aren't on
> modules.order are put after modules which are ordered by
> modules.order.

Thanks. Please CC me in general on these patches :-)

I was planning to also discuss ordering of module aliases entries, since
we can have several modules providing the same modalias (this gets even
worse on "Enterprise Linux" distributions, where we might have third
party modules providing additional aliases). I guess this ordering is
probably better than just a numeric sort, which was the original idea.

Jon.



