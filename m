Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXL0Cei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXL0Cei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 21:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXL0Cea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 21:34:30 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54521 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbXL0Ce3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 21:34:29 -0500
Message-ID: <47730F2F.3080900@garzik.org>
Date: Wed, 26 Dec 2007 21:34:23 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: saeed bishara <saeed.bishara@gmail.com>
CC: linux-kernel@vger.kernel.org, NFS list <linux-nfs@vger.kernel.org>
Subject: Re: read-ahead in NFS server
References: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>
In-Reply-To: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

saeed bishara wrote:
> Hi,
> my NFS server seems not to utilize the read-ahead feature, my exported
> dir is located on ext3 fs over sata disk. the sata controller can
> issue commands up to 1MB, also I modified the read ahead under the sys
> to 1MB. but when the client do reads in 32KB chunks (rsize), I can see
> in the server side that all IOs are ~32KB. my kernel version is
> 2.6.22.7.
> according to the nfsd code, the NFS server should utilize the
> read-ahead feature, but what should I do
> to make it work?

(linux-nfs added to cc)

I cannot speak for the NFS server code specifically, but 32kb sounds 
like a network read (or write) data size limit.

Are you using TCP?  Are you using NFSv4, or an older version?

	Jeff


