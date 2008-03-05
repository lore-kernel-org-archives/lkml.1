Return-Path: <linux-kernel-owner+w=401wt.eu-S932492AbYCEX0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbYCEX0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbYCEXZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:25:57 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:5136 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbYCEXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bsfBo/a+Ubzzq9IyX0uNsSOljFlzDzNAEeifFT/IqnYefC//I4FoecOzWxTgIgUvy3LrXwUE1cGCbBukBT1cxOPUIIJL1hPWLsBe3RuF//GiLrv8RP3y3b/rtxcALqXe8o/bLpb35mFxeGV/DRFvbRjjYvvCTDDqr+yTpy7Jo5c=
Message-ID: <8b67d60803051525g3aca775dmc14d1c2450b34168@mail.gmail.com>
Date: Wed, 5 Mar 2008 23:25:48 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Greg KH" <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Behaviour of device_register
Cc: linux-sh <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The observed behaviour for me is that it appears to be blocking the
vblank interrupt on my box (or more accurately stopping the workqueue
that the interrupt handler calls from running). And without the vblank
my bus won't process dma and so therefore the attempt to register the
device in question fails.

But I can see no reason from a glance over the code why that (vblanks
being blocked) would be the case - have I missed something and the
vblanks will be blocked, or should I be looking elsewhere for the root
cause of this problem?

Thanks

Adrian
