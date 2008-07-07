Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYGGEVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYGGEVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 00:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYGGEVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 00:21:38 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4245 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYGGEVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 00:21:38 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Michael Chan" <mchan@broadcom.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "Bastian Blank" <bastian@waldi.eu.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 6 Jul 2008 21:21:21 -0700
Subject: Re: [PATCH] bnx2 - use request_firmware()
Thread-Topic: [PATCH] bnx2 - use request_firmware()
Thread-Index: Acjeg+nw/mwwUQOVSyqJr7XJJ3yyogBY0fkw
Message-ID: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <1215251041.3189.69.camel@shinybook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
acceptlanguage: en-US
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Jul 2008 04:21:21.0604 (UTC)
 FILETIME=[E916A040:01C8DFE8]
X-WSS-ID: 646F464263S90001517-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:

> But if _Michael_ signs off on it, and if you can provide it
> in the form
> used in the firmware-2.6.git tree, with the firmware files added into
> the firmware/ subdirectory so they're still being shipped with the
> kernel and the user doesn't have to go find them elsewhere, then I
> suppose I'll probably take it.
>

I cannot sign off on this until I understand more about the impact
of this change.  Unlike the tg3 firmware which hasn't changed for at
least 4 or 5 years, the bnx2 firmware is constantly changing and it
has to match the driver.  For example, we'll be adding multi-tx ring
to the driver soon and it will require the feature in the firmware.

