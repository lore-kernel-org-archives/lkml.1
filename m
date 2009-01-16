Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbZAPTD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbZAPTD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759828AbZAPTDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:03:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757922AbZAPTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:03:46 -0500
Date: Fri, 16 Jan 2009 11:03:47 -0800 (PST)
Message-Id: <20090116.110347.196376948.davem@davemloft.net>
To: dhananjay@netxen.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] netxen: avoid invalid iounmap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1232130484-25188-2-git-send-email-dhananjay@netxen.com>
References: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
	<1232130484-25188-2-git-send-email-dhananjay@netxen.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhananjay Phadke <dhananjay@netxen.com>
Date: Fri, 16 Jan 2009 10:28:03 -0800

> For NX3031 only one I/O range is mapped, so unmapping other
> two which are used by older chips, causes this warning on
> ppc64.
> 
> "Attempt to iounmap early bolted mapping at 0x0000000000000000"
> 
> Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>

Applied.
