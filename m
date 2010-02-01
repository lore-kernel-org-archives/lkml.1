Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0BASCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:02:35 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:65453 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184Ab0BASCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:02:34 -0500
From: Frans Pop <elendil@planet.nl>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line formats
Date: Mon, 1 Feb 2010 19:02:31 +0100
User-Agent: KMail/1.9.9
Cc: joe@perches.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <cover.1264967493.git.joe@perches.com> <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com> <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com> <1265044616.6910.15.camel@mulgrave.site>
In-reply-To: <1265044616.6910.15.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002011902.33015.elendil@planet.nl>
X-OriginalArrivalTime: 01 Feb 2010 18:02:33.0239 (UTC) FILETIME=[BA61FA70:01CAA368]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> -                     printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
>> -                     timeout, retry count down = %d \n", acb->host->host_no, retry_count);
> 
> So I might personally dislike this style

The problem here is not style, but that the whitespace of the indentation
on the second line becomes part of the output!
That makes the code defective and is why Joe posted the patch series.

Cheers,
FJP
