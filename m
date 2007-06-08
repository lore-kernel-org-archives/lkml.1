Return-Path: <linux-kernel-owner+w=401wt.eu-S938105AbXFHMVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938105AbXFHMVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763659AbXFHMVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:21:34 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:54358 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757462AbXFHMVd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:21:33 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 00/32] 2.6.20-stable review
Date: Fri, 8 Jun 2007 08:21:07 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B01289C1@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20070608071511.159309000@sous-sol.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 00/32] 2.6.20-stable review
Thread-Index: AcepnRBP7GPuAyoiRkGyPxrptjNAigAKHlUg
References: <20070608071511.159309000@sous-sol.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Chris Wright" <chrisw@sous-sol.org>, <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>
X-OriginalArrivalTime: 08 Jun 2007 12:21:07.0803 (UTC) FILETIME=[7DD4C2B0:01C7A9C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Chris Wright
> Envoyé : 8 juin 2007 03:15
> 
> This is the start of the stable review cycle for the 
> 2.6.20.14 release.
> There are 32 patches in this series, all will be posted as a 
> response to this one.  If anyone has any issues with these 
> being applied, please let us know.  If anyone is a maintainer 
> of the proper subsystem, and wants to add a Signed-off-by: 
> line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the
> Cc: line.  If you wish to be a reviewer, please email 
> stable@kernel.org to add your name to the list.  If you want 
> to be off the reviewer list, also email us.
> 
> Responses should be made by Sun Jun 10 07:15 UTC.
> Anything received after that time might be too late.

Hi Chris,

I have encoutered a bug using fixdep when compiling the Apani VPN contivity client v3.3 (v3.5 seems fine).  The bug started happening with the release of the 2948 build of FC6 kernel (corresponding to a post 2.6.20.7) and caused fixdep to segfault.  This has been fixed in 2.6.21.  I tried to trigger the bug using the 2.6.21 patch (thnx to the raw ouput option in git.kernel.org) and it really seems to resolve the problem.

The original commit:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git;a=commit;h=3dedd29b0ef5c7a36ac835ac5524a6a8e22c22ab

The fix:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=commit;h=1ea6b2418cd2c6a6f31067ed6ece5cd12c69351e

Could it be included in this new stable release of 2.6.20 ?

thnx

> thanks,
> 
> the -stable release team
> --
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
