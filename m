Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbYABGTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbYABGTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYABGTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:19:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52122 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbYABGTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:19:23 -0500
Message-ID: <477B2CE4.8070602@garzik.org>
Date: Wed, 02 Jan 2008 01:19:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kluo@nvidia.com, AMartin@nvidia.com, pchen@nvidia.com
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <477B10F2.9000107@shaw.ca> <477B1233.3090706@gmail.com>
In-Reply-To: <477B1233.3090706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Thanks a lot for the detailed explanation.  Nvidia ppl, any ideas?
> FLUSH is used regularly.  We really need to fix this.


I reiterate my opinion :)  ...   We should remove ADMA support from 
sata_nv.  It's only in a few chips, it's not appearing in any new chips, 
and nasty problems have lingered since ADMA support was introduced.

Definitely sounds like we should disable ADMA by default for 2.6.24-rc, too.

	Jeff


