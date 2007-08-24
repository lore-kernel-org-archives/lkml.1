Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXHXQJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXHXQJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXHXQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:08:54 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2372 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXHXQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:08:53 -0400
Date: Fri, 24 Aug 2007 18:08:34 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
Message-ID: <20070824160834.GA7029@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just got:

  Building modules, stage 2.
  MODPOST 414 modules
ERROR: "scsi_normalize_sense" [drivers/md/dm-rdac.ko] undefined!
make[1]: *** [__modpost] Error 1

Presumably DM_MULTIPATH_RDAC needs to depend on SCSI (not enabled
here) since it uses scsi_normalize_sense.
-- 
Martin Michlmayr
http://www.cyrius.com/
