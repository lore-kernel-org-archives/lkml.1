Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXJKVtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXJKVtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbXJKVtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:49:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42292
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755683AbXJKVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:49:40 -0400
Date: Thu, 11 Oct 2007 14:49:28 -0700 (PDT)
Message-Id: <20071011.144928.45188136.davem@davemloft.net>
To: rob@landley.net
Cc: bunk@kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] esp_scsi.c: remove __dev{init,exit}
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710111747.03119.rob@landley.net>
References: <1192109439.3352.11.camel@localhost.localdomain>
	<20071011153520.GA16424@stusta.de>
	<200710111747.03119.rob@landley.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>
Date: Thu, 11 Oct 2007 17:47:02 -0500

> On Thursday 11 October 2007 10:35:20 am Adrian Bunk wrote:
> > Since scsi_esp_{,un}register() are EXPORT_SYMBOL'ed, these functions
> > (and the functions they use) can't be __dev{init,exit}.
> >
> > Based on a bug report by Rob Landley.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Acked-by: Rob Landley <rob@landley.net>

I'm fine with this fix too.

Acked-by: David S. Miller <davem@davemloft.net>
