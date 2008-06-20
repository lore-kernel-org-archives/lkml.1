Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbYFTFJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbYFTFJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 01:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYFTFIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 01:08:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:64957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYFTFIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 01:08:53 -0400
From: Stefan Roese <sr@denx.de>
To: linux-mtd@lists.infradead.org
Subject: Re: [PATCH] jedec_probe: Fix SST 16-bit chip detection
Date: Fri, 20 Jun 2008 07:08:37 +0200
User-Agent: KMail/1.9.9
Cc: David Woodhouse <dwmw2@infradead.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp> <1213896113.26255.1434.camel@pmac.infradead.org>
In-Reply-To: <1213896113.26255.1434.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806200708.37974.sr@denx.de>
X-Provags-ID: V01U2FsdGVkX1+1Hpn06XqOcMKMkWVol205waqJQ7CQJL44DrM
 85uXA25Ty+9tM99nzm5EoD5C3g01TxZzaBymjjjoGWNw6TyQtZ
 AUZV2dFTqKVSVznGfHKUmURk8Mx71OJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2008, David Woodhouse wrote:
> On Thu, 2008-06-19 at 16:36 +0900, Atsushi Nemoto wrote:
> > -               .devtypes       = CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
> > +               .devtypes       = CFI_DEVICETYPE_X16,
>
> I believe you about the uaddr -- but can these devices really not be
> used in 8-bit mode?

No. They are 16-bit only.

Best regards,
Stefan
