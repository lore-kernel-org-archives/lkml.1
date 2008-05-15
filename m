Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYEOFer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYEOFer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYEOFef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:34:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36410
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbYEOFee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:34:34 -0400
Date: Wed, 14 May 2008 22:34:29 -0700 (PDT)
Message-Id: <20080514.223429.249318607.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: greg@kroah.com, fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080514181603.411e834f@extreme>
References: <20080514170316.672f809d@extreme>
	<20080514181257.74fbb5aa@extreme>
	<20080514181603.411e834f@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 14 May 2008 18:16:03 -0700

> It is possible that the entry in sysfs already exists, one case of this is
> when a network device is renamed to bonding_masters. Anyway, in this case
> the proper error path is for device_rename to return an error code, not to
> generate bogus backtrace and errors.
> 
> Also, to avoid possible races, the create link should be done before the
> remove link. This makes a device rename atomic operation like other renames.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
