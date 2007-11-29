Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXK2NmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXK2NmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXK2Nl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:41:56 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3002 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbXK2Nlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:41:55 -0500
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: PATCH 2.6.24-rc3-mm2 - build breakage - bnx2x depends on
 ZLIB_INFLATE
From: "Eliezer Tamir" <eliezert@broadcom.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
cc: "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jeff@garzik.org" <jeff@garzik.org>
In-Reply-To: <1196281524.5318.19.camel@localhost>
References: <1196281524.5318.19.camel@localhost>
Date: Thu, 29 Nov 2007 15:41:33 +0200
Message-ID: <1196343693.17721.47.camel@lb-tlvb-eliezer.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0
X-WSS-ID: 6B501E1A0SG13466404-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-28 at 12:25 -0800, Lee Schermerhorn wrote:
> Couldn't find one of these on the lists...
> 
> PATCH 2.6.24-rc3-mm1:  bnx2x depends on ZLIB_INFLATE
> 
> The bnx2x module depends on the zlib_inflate functions.  The
> build will fail if ZLIB_INFLATE has not been selected manually
> or by building another module that automatically selects it.
> 
> Modify BNX2X config option to 'select ZLIB_INFLATE' like BNX2
> and others.  This seems to fix it.
> 
> Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

You are right.
My mistake, Thanks.

Acked-by: Eliezer Tamir <eliezert@broadcom.com>


