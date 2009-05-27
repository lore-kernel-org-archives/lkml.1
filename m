Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZE0RMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZE0RMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZE0RMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:12:44 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:49602 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZE0RMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:12:43 -0400
X-BigFish: VPS-26(zz1432R98dR148cM1805Mzz1202hzzz32i6bh6di43j)
X-FB-SS: 13,
X-WSS-ID: 0KKBBSR-02-7IB-01
Date: Wed, 27 May 2009 19:12:31 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: linux-next: edac-amd tree build warning
Message-ID: <20090527171231.GA31292@aftab>
References: <20090527170119.c1d6b221.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090527170119.c1d6b221.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 27 May 2009 17:12:33.0688 (UTC) FILETIME=[533D5180:01C9DEEE]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, May 27, 2009 at 05:01:19PM +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/edac/amd64_edac.c: In function 'f10_get_base_addr_offset':
> drivers/edac/amd64_edac.c:1466: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
> 
> Introduced by commit c266e41c0ca15d5df65e42d07608fbfb51ff32e3
> ("amd64_edac: add F10h-and-later methods-p2").

Thanks for catching that. Fixed and rebased on latest Linus' tree.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

