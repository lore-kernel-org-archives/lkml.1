Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZJJV57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZJJV57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZJJV57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:57:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:49585 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZJJV56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:57:58 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 08:56:23 +1100
Message-Id: <1255211783.3387.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Further REQUEST SENSE commands therefore requested 96 bytes of data
> instead of the standard 18 bytes.  With LUN 0 this worked okay.  But 
> with LUN 1 it didn't; the device reported a failure of the REQUEST 
> SENSE.  This is what caused usb-storage to issue the device reset.
> 
> After the reset usb-storage continued to ask for 96 bytes of sense
> data, and LUN 1 continued to fail the commands.  Hence the repeated
> resets.

Maybe a better approach would be to go back to 18 bytes when it fails,
what do you think ?

Ben.


