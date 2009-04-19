Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZDSSb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZDSSb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZDSSbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:31:46 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56577 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZDSSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:31:45 -0400
Date: Sun, 19 Apr 2009 19:31:43 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #13120] BUG: using rootfstype=ext4 causes oops
Message-ID: <20090419183143.GB24066@sucs.org>
Mail-Followup-To: Andrew Price <andy@andrewprice.me.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.zGH.Fw85JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nY3-4PrO6XH.A.zGH.Fw85JB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 11:45:07PM +0200, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13120
> Subject		: BUG: using rootfstype=ext4 causes oops
> Submitter	: Andrew Price <andy@andrewprice.me.uk>
> Date		: 2009-04-15 20:59 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=123982932807371&w=4
> Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123991090816794&w=4

Fixed in commit f505d49ffd25ed062e76ffd17568d3937fcd338c "ide: fix
barriers support" (which was merged in
df89f1ba971b3df2b7e1bc46ca7ce867539186fa ).

--
Andrew Price
