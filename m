Return-Path: <linux-kernel-owner+w=401wt.eu-S965332AbXBLTdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbXBLTdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965333AbXBLTdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:33:14 -0500
Received: from smtp-out-43.synserver.de ([217.119.50.43]:37096 "HELO
	smtp-out-43.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965332AbXBLTdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:33:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-ViaOpenRelay-IP: 212.202.34.50
X-SynServer-RBL-IP: 212.202.34.50
X-SynServer-RBL-ReportedBy: dynablock.njabl.org
X-SynServer-RBL-ReportedByCount: *
X-SynServer-RBL-Weights: 100
X-SynServer-RBL-WeightSum: 100
X-SynServer-RBL-WeightStr: **********
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Mon, 12 Feb 2007 20:33:02 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_via: fix resource-managed iomap conversion
Message-ID: <20070212193302.GA5003@gentoox2.trippelsdorf.de>
References: <20070210010914.GA19717@havoc.gtf.org> <20070210054629.GA4395@gentoox2.trippelsdorf.de> <45CF93D1.9080009@gmail.com> <20070212025843.GA4406@gentoox2.trippelsdorf.de> <45D0B740.9050704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D0B740.9050704@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 10:51:44AM -0800, Tejun Heo wrote:
> Conversion to resource-managed iomap was buggy causing init failures
> on both vt6420 and 6421 - BAR5 wasn't mapped for both controllers
> while on vt6420 sata_via tried to map BAR0-4 twice.  Fix it.
> 
> DO NOT APPLY YET.
> ---
> Markus, does this fix your problem?

Yes it does. Thank you very much. I appreciate your work.
-- 
Markus
