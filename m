Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZDNLKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZDNLKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZDNLKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZDNLKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:01 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
Subject: [PATCH 0/6] Handle bio_alloc failure
Date: Tue, 14 Apr 2009 16:36:25 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.26557.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

Some of the callers of bio_alloc() assume that it will never fail and always 
return bios. But it can fail. This patch set changes those callers to take 
action when bio_alloc() fails.

Thanks
Nikanth

