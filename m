Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYGXSqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYGXSqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYGXSq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:46:29 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:64712 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYGXSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:46:29 -0400
Date: Thu, 24 Jul 2008 20:46:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: Frank Blaschka <frank.blaschka@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [BUG] qeth doesn't work anymore because of netdev_priv changes
Message-ID: <20080724184624.GB8969@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

git commit e3c50d5d25ac09efd9acbe2b2a3e365466de84ed
"netdev: netdev_priv() can now be sane again." breaks qeth on s390
(no more networking possible). Reverting the patch fixes it.
I haven't looked into this any further.

Thanks,
Heiko
