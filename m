Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXH3J45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXH3J45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXH3J4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:56:50 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2681 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753559AbXH3J4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:56:49 -0400
Date: Thu, 30 Aug 2007 11:57:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add power meters to
 Documentation/hwmon/sysfs-interface
Message-ID: <20070830115743.4dd8b2d5@hyperion.delvare>
In-Reply-To: <20070829145002.GQ32667@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828164440.GL32667@tree.beaverton.ibm.com>
	<20070829111052.503a73a5@hyperion.delvare>
	<20070829145002.GQ32667@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Wed, 29 Aug 2007 07:50:03 -0700, Darrick J. Wong wrote:
> On Wed, Aug 29, 2007 at 11:10:52AM +0200, Jean Delvare wrote:
> 
> > I'm not sure if we want these "historical" files. We don't have them for
> > the other input types, and I believe that it's not the driver's job to
> > compute and export these values. If anyone cares about the history of
> 
> In the case of ibmpex, it is the _hardware_ that computes the historical
> data; the driver merely exports what it sees.

OK, that's a bit different then, but I'm still not sure that there is
much value in exporting these values in sysfs, in particular if there
is no way to reset them.

I am also not happy with the names you proposed: power1_max_input and
power1_min_input are somewhat confusing IMHO, I'd suggest
power1_input_highest and power1_input_lowest to make them clearly
different from the min and max limits we have for other sensor types.
If we have them at all, of course.

-- 
Jean Delvare
