Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbYF3LsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbYF3LsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYF3LsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:48:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:58308 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbYF3LsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:48:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,727,1204531200"; 
   d="scan'208";a="4533440"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/3] mmc: fix sdio_io sparse errors
Date: Mon, 30 Jun 2008 14:48:06 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F8010415E5E1@hasmsx412.ger.corp.intel.com>
In-Reply-To: <1214816462.11537.26.camel@violet.holtmann.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] mmc: fix sdio_io sparse errors
Thread-Index: Acjaj+dFg0ZYN3P2QpCtPeJ2avWPCwAFtjqw
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com> <1214812224-32267-2-git-send-email-tomas.winkler@intel.com> <1214812224-32267-3-git-send-email-tomas.winkler@intel.com> <1214816462.11537.26.camel@violet.holtmann.net>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Cc: <drzeus-list@drzeus.cx>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Jun 2008 11:48:10.0199 (UTC) FILETIME=[2B5D5670:01C8DAA7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Marcel Holtmann [mailto:marcel@holtmann.org]
>Sent: Monday, June 30, 2008 12:01 PM
>To: Winkler, Tomas
>Cc: drzeus-list@drzeus.cx; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 3/3] mmc: fix sdio_io sparse errors
>
>Hi Tomas,
>
>> This patch fixes sdio_io sparse errors.
>> This fix changes signature of API functions,
>> changing
>> unsigned char -> u8
>> unsigned short -> u16
>> unsigned long -> u32 - this was probably a bug in 64 bit platforms
>
>why are we not using the new get_unaligned_le* and put_unaligned_le*
>functions for the tmpbuf access?
>
It resides inside sido_func structure there is no reason it will be
unaligned.
Tomas 

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

