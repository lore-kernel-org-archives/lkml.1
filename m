Return-Path: <linux-kernel-owner+w=401wt.eu-S939227AbXG3JeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939227AbXG3JeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbXG3JeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:34:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3009 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765851AbXG3JeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:34:11 -0400
Message-ID: <46ADB08F.3060601@shadowen.org>
Date: Mon, 30 Jul 2007 10:34:07 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: rdunlap@xenotime.net, jschopp@austin.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl false positive on exported pointers
References: <e9c3a7c20707290928r53bf2530ue02c5e1d4f03be46@mail.gmail.com>
In-Reply-To: <e9c3a7c20707290928r53bf2530ue02c5e1d4f03be46@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #563: FILE: drivers/scsi/iioc34x/iioc34x_sas.c:58:
> +EXPORT_SYMBOL(iioc34x_transport_template);
> 
> drivers/scsi/iioc34x/iioc34x_sas.c:57
> struct scsi_transport_template *iioc34x_transport_template;
> EXPORT_SYMBOL(iioc34x_transport_template);
> 
> I suspect the script wants:
> EXPORT_SYMBOL(*iioc34x_transport_template);
> ...but that does not compile.

Thanks for the report.  Will look into this for the next update.

-apw
