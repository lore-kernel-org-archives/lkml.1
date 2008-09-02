Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYIBTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYIBTN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYIBTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:13:50 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49697 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYIBTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:13:49 -0400
Date: Tue, 02 Sep 2008 13:13:33 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] UBIFS: fill f_fsid
In-reply-to: <1220376569.2982.225.camel@pmac.infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Message-id: <20080902191333.GL3086@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
 <1220262187.2982.58.camel@pmac.infradead.org>
 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
 <20080902170954.GE3086@webber.adilger.int>
 <1220376569.2982.225.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 02, 2008  18:29 +0100, David Woodhouse wrote:
> Yes, putting st_dev in f_fsid probably isn't a good thing to do.
> 
> I realised that we already have the
> f_fsid field in struct statfs, and we might as well just use that. That
> does seem to be what it was _designed_ for, after all.

My bad - I had looked back in email archives about this issue and got
the export operation solution stuck in my head...

Yes, using f_fsid is the right way to do this, assuming NFSD plays along.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

