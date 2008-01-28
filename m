Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYA1OLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYA1OLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbYA1OKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:10:47 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1508 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbYA1OKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:10:45 -0500
Date: Mon, 28 Jan 2008 14:10:17 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: warn about using __FUNCTION__
Message-ID: <20080128141017.GG12910@shadowen.org>
References: <200801142319.48150.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801142319.48150.bzolnier@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 11:19:48PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> __FUNCTION__ is gcc specific, __func__ is C99
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Research seems to indicate this is indeed sensible as __FUNCTION__ can
cause -Werror to trip.  Have applied this for 0.14.

Thanks.

-apw
