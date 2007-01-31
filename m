Return-Path: <linux-kernel-owner+w=401wt.eu-S1161030AbXAaUVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161030AbXAaUVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161033AbXAaUVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:21:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51998 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161025AbXAaUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:21:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45C0FA3B.5030508@s5r6.in-berlin.de>
Date: Wed, 31 Jan 2007 21:21:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, htejun@gmail.com
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
References: <45BD522F.3070706@shaw.ca> <20070129154706.dfb3edab.akpm@osdl.org> <1170116201.3378.29.camel@mulgrave.il.steeleye.com> <45BE9252.3040108@shaw.ca>
In-Reply-To: <45BE9252.3040108@shaw.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>> http://marc.theaimsgroup.com/?t=116922621200002
> 
> It looks like Tejun's patch essentially does the same thing as mine with
> the addition of the control from userspace. There is one exception
> though, my patch also does the stop on removal of the SCSI disk (i.e.
> writing 1 to its "delete" file in sysfs, what scsiadd -r does).

Isn't sd_shutdown called at this occasion?
-- 
Stefan Richter
-=====-=-=== ---= =====
http://arcgraph.de/sr/
