Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZI2OMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZI2OMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZI2OMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:12:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZI2OMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:12:33 -0400
Subject: Re: [PATCH] drivers/scsi/libsas: Use SAM_GOOD
From: James Bottomley <James.Bottomley@suse.de>
To: Julia Lawall <julia@diku.dk>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909290759420.29620@ask.diku.dk>
References: <Pine.LNX.4.64.0909290759420.29620@ask.diku.dk>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 14:12:26 +0000
Message-Id: <1254233546.3942.36.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-29 at 08:00 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The field stat->stat should be compared to SAM_GOOD, not SAM_STAT_GOOD, as
> done elsewhere in the same function.  Both constants have the same value.

Actually, I'd like to see us go the other way.  Use the standard SCSI
defined SAM_STAT macros in libsas instead of its hand rolled
equivalents.  This would mean modifying aic94xx/aic94xx_task.c and
libsas.h as well.

Thanks,

James


