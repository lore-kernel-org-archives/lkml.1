Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbXKVSRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbXKVSRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXKVSRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:17:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXKVSRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:17:15 -0500
Date: Thu, 22 Nov 2007 19:17:14 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: Why is FIBMAP ioctl root only?
Message-ID: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I guess subject says it all - why is FIBMAP ioctl restricted only to
root (CAP_SYS_RAWIO)? Corresponding ioctl for XFS is allowed without any
special capabilities so we are inconsistent here too...
  Would anyone mind if the check is removed?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
