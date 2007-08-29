Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbXH2JtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbXH2JtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 05:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXH2JtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 05:49:12 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2071 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753473AbXH2JtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 05:49:10 -0400
Date: Wed, 29 Aug 2007 11:49:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       "Yani Ioannou" <yani.ioannou@gmail.com>
Subject: Re: [lm-sensors] [PATCH] v1 of IBM power meter driver
Message-ID: <20070829114959.5ddb8d79@hyperion.delvare>
In-Reply-To: <20070828162851.GJ32667@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828162851.GJ32667@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, 28 Aug 2007 09:28:51 -0700, Darrick J. Wong wrote:
> On Tue, Aug 28, 2007 at 01:19:42PM +0200, Jean Delvare wrote:
> > I see that the driver relies on IPMI. Can't it be merged with the
> > out-of-tree impisensors driver then? This would give that driver some
> > momentum so that it can finally be merged, and I would like to avoid
> > having two drivers if one is enough. Note though that I don't know
> > anything about IPMI so I might as well be totally wrong ;)
> 
> The IBM PEx meters are accessible via custom IPMI commands, not the
> standard IPMI sensor interface.  I considered modifying the ipmisensors
> driver, but reached the opinion that it would clutter that driver
> unnecessarily, particularly since there are a lot of systems with IPMI
> BMCs, but most of them will not have this interface.

OK, fine with me then.

> That said, what is standing in the way of ipmisensors being merged?  I
> think I can shake out some free time to apply TLC.

I don't know exactly, check out the website for details:
  http://bmcsensors-26.sourceforge.net/

It needs at least review and testing, but maybe there are a few more
steps before merging can be considered. Adding Yani (the author) to Cc,
please work with him if you're interested.

-- 
Jean Delvare
