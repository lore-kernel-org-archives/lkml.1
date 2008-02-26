Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbYBZWNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbYBZWNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYBZWNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:13:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59660
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbYBZWN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:13:29 -0500
Date: Tue, 26 Feb 2008 14:14:13 -0800 (PST)
Message-Id: <20080226.141413.223249736.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: dsd@gentoo.org, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org,
       stephen.hemminger@vyatta.com
Subject: Re: Linux 2.6.24.3 (if_addrlabel.h HEADERS_CHECK failure)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080226072943.083c3809@extreme>
References: <20080225195229.11ec1f12.randy.dunlap@oracle.com>
	<47C42477.5090900@gentoo.org>
	<20080226072943.083c3809@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 26 Feb 2008 07:29:43 -0800

> On Tue, 26 Feb 2008 14:38:47 +0000
> Daniel Drake <dsd@gentoo.org> wrote:
> 
> > Randy Dunlap wrote:
> > This appears to have been caused by the patch titled:
> > 
> > 	NET: Add if_addrlabel.h to sanitized headers.
> > 
> > The patch only adds the unifdef-y entry for this header file, however 
> > that header was only added after 2.6.24.
> > 
> > It seems that this patch was submitted to -stable in error. Stephen, can 
> > you confirm?
> 
> The patch was meant for 2.6.25 only. 

My bad, please revert :(
