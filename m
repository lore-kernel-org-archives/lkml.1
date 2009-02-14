Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZBNKEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZBNKEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 05:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZBNKEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 05:04:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37712
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbZBNKEg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 05:04:36 -0500
Date: Sat, 14 Feb 2009 02:04:31 -0800 (PST)
Message-Id: <20090214.020431.193689843.davem@davemloft.net>
To: michel@daenzer.net
Cc: benh@kernel.crashing.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: drm: radeon: Use surface for PCI GART table.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234605599.4823.177.camel@thor>
References: <20090214.015107.127190039.davem@davemloft.net>
	<1234605599.4823.177.camel@thor>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <michel@daenzer.net>
Date: Sat, 14 Feb 2009 10:59:59 +0100

> On Sat, 2009-02-14 at 01:51 -0800, David Miller wrote:
> > This allocates a physical surface for the PCI GART table, this way no
> > matter what other surface configurations exist the GART table will
> > always be seen by the hardware properly.
> 
> BTW, I don't think the swapping settings affect GPU access to the table,
> only CPU access, but this is a good solution anyway.

They absolutely and positively do effect GPU access to the table.
I've proven it with many conclusive tests over the past 3 days.

> This is only really necessary on big endian, but other than that:
> 
> Acked-By: Michel Dänzer <daenzer@vmware.com>

Thanks.
