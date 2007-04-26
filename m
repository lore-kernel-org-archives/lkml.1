Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbXDZT2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbXDZT2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbXDZT2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:28:40 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:48419 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754945AbXDZT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:28:39 -0400
Subject: RE: [PATCH] scsi: megaraid_sas - intercepts cmd timeout
	andthrottle io
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229A5922C@NAMAIL2.ad.lsil.com>
References: <0631C836DBF79F42B5A60C8C8D4E8229A5922C@NAMAIL2.ad.lsil.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 15:28:27 -0400
Message-Id: <1177615707.6284.135.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 11:52 -0600, Patro, Sumant wrote:
>         The rsvd[3] is reserved for future use. If you have objection to
> the definition I will take it out in a future patch submission.

But this is a structure that's internal to the driver isn't it?  It's
not shared with the card, so there's no need to pad it or reserve
elements ... you can add anything you need at the point you need it.

James


