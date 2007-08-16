Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbXHPHbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbXHPHbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXHPHbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:31:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:23378 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbXHPHbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:31:08 -0400
Date: Thu, 16 Aug 2007 10:30:58 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>, lenb@kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>
Subject: Re: [PATCH 3/3] ACPI: thinkpad-acpi: change thinkpad-acpi input
	default and kconfig help
Message-ID: <20070816073053.GA19833@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <11868017142597-git-send-email-hmh@hmh.eng.br>
	<11868017143582-git-send-email-hmh@hmh.eng.br>
	<20070811180602.GA17843@mellanox.co.il>
	<20070811221625.GB27761@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811221625.GB27761@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I *can* make the compile-time option a module parameter, though.  That
> wouldn't be much of a problem, and the compile-time option would select the
> default for that parameter, but it would be easier to override it at run
> time (you can already do it, but it requires reprogramming various driver
> parameters using sysfs and the input device IOCTLs).
> 
> Would a module parameter address enough of your concerns?  Kconfig would
> only set the default for that parameter, then...

I really think modifying defaults it not a great idea.
What about adding a writeable module parameter?
Then new HAL would just write to /sysfs/module/thinkpad/parameters/interface_version to 
switch to new behaviour.

-- 
MST
