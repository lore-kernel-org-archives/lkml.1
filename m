Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZGMRcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZGMRcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZGMRcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:32:41 -0400
Received: from smtp.mppmu.mpg.de ([134.107.24.58]:49892 "EHLO
	smtp.mppmu.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbZGMRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:32:40 -0400
Date: Mon, 13 Jul 2009 19:05:19 +0200 (CEST)
From: Peter Breitenlohner <peb@mppmu.mpg.de>
To: Karel Zak <kzak@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2 -- a small patch
In-Reply-To: <20090702181031.GB4122@nb.net.home>
Message-ID: <alpine.LNX.2.00.0907131900290.31109@pcl321.mppmu.mpg.de>
References: <20090702181031.GB4122@nb.net.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1803957763-1937402321-1247504719=:31109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1803957763-1937402321-1247504719=:31109
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Thu, 2 Jul 2009, Karel Zak wrote:

> The second util-linux-ng 2.16 release candidate is available at
>
>   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/
>
> Feedback and bug reports, as always, are welcomed.

Hi Karel,

I just tried to build util-linux-ng-2.16-rc2 (i686/x86_64 linux-gnu
with gcc-3.4.6, libc-2.3.6), but in order to succeed I had to apply the
attached patch (#include <stdarg.h> from shlibs/blkid/src/blkidP.h).

Regards
Peter
--1803957763-1937402321-1247504719=:31109
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=util-linux-ng-2.16-rc2-patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.0907131905190.31109@pcl321.mppmu.mpg.de>
Content-Description: 
Content-Disposition: attachment; filename=util-linux-ng-2.16-rc2-patch

ZGlmZiAtdXIgLXggTWFrZWZpbGUuaW4gLXggJyoubTQnIC14IGNvbmZpZ3Vy
ZSAteCBhdXRvbTR0ZS5jYWNoZSAteCBNYWtldmFycy50ZW1wbGF0ZSAteCAn
Ki5nbW8nIHV0aWwtbGludXgtbmctMi4xNi1yYzIub3JpZy9zaGxpYnMvYmxr
aWQvc3JjL2Jsa2lkUC5oIHV0aWwtbGludXgtbmctMi4xNi1yYzIvc2hsaWJz
L2Jsa2lkL3NyYy9ibGtpZFAuaA0KLS0tIHV0aWwtbGludXgtbmctMi4xNi1y
YzIub3JpZy9zaGxpYnMvYmxraWQvc3JjL2Jsa2lkUC5oCTIwMDktMDctMDEg
MTc6MTk6NTQuMDAwMDAwMDAwICswMjAwDQorKysgdXRpbC1saW51eC1uZy0y
LjE2LXJjMi9zaGxpYnMvYmxraWQvc3JjL2Jsa2lkUC5oCTIwMDktMDctMTMg
MTg6NTM6NTMuMDAwMDAwMDAwICswMjAwDQpAQCAtMTgsNiArMTgsNyBAQA0K
IA0KICNpbmNsdWRlIDxzeXMvdHlwZXMuaD4NCiAjaW5jbHVkZSA8c3RkaW8u
aD4NCisjaW5jbHVkZSA8c3RkYXJnLmg+DQogDQogI2luY2x1ZGUgImJpdG9w
cy5oIgkvKiAkKHRvcF9zcmNkaXIpL2luY2x1ZGUvICovDQogI2luY2x1ZGUg
ImJsa2lkLmgiDQo=

--1803957763-1937402321-1247504719=:31109--
