Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZLSEOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZLSEOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 23:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZLSEN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 23:13:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33226
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbZLSEN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 23:13:59 -0500
Date: Fri, 18 Dec 2009 20:14:00 -0800 (PST)
Message-Id: <20091218.201400.260092381.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: bjorn.helgaas@hp.com, amit.salecha@qlogic.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: NetXen crash in sysfs_create_file
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091218162054.7b19d98f@nehalam>
References: <200912181324.29906.bjorn.helgaas@hp.com>
	<20091218162054.7b19d98f@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 18 Dec 2009 16:20:54 -0800

> Subject: [PATCH] netxen: use module parameter correctly
> 
> Netxen driver is doing this bogus thing to create a control file.
> This fails if device doesn't exist, and overall is a bad way to do
> the module parameter. Rather than fix borked code, just rewrite.
> Just using a writeable module parameter of 0/1 is the correct way
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied, thanks Stephen.
