Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbYA3Nxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbYA3Nxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYA3NxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:53:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36407
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756011AbYA3NxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:53:14 -0500
Date: Wed, 30 Jan 2008 05:53:33 -0800 (PST)
Message-Id: <20080130.055333.192844925.davem@davemloft.net>
To: ballen@gravity.phys.uwm.edu
Cc: linux-kernel@vger.kernel.org, henning.fehrmann@aei.mpg.de,
       carsten.aulbert@aei.mpg.de, bruce.allen@aei.mpg.de,
       netdev@vger.kernel.org
Subject: Re: e1000 full-duplex TCP performance well below wire speed
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allen <ballen@gravity.phys.uwm.edu>
Date: Wed, 30 Jan 2008 03:51:51 -0600 (CST)

[ netdev@vger.kernel.org added to CC: list, that is where
  kernel networking issues are discussed. ]

> (The performance of a full duplex stream should be close to 1Gb/s in
> both directions.)

This is not a reasonable expectation.

ACKs take up space on the link in the opposite direction of the
transfer.

So the link usage in the opposite direction of the transfer is
very far from zero.
