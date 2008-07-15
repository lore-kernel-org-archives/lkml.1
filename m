Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYGOPSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYGOPSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYGOPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:17:52 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47631 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYGOPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:17:51 -0400
Subject: Re: [PATCH 3/4] BUG_ON on kernel misbehavior on A100U2W driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
	 <Pine.LNX.4.64.0807151011350.24544@devserv.devel.redhat.com>
	 <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 10:17:47 -0500
Message-Id: <1216135067.3312.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 10:14 -0400, Mikulas Patocka wrote:
> With broken Sparc64 IOMMU accounting, the kernel submits larger requests 
> then allowed. Better to crash on BUG than corrupt memory. This needs to be 
> fixed in sparc64 code.

This analysis is correct ... and the reason we don't add driver work
arounds, so it really needs to be fixed in sparc, not worked around in
the driver.

James


