Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZJSMvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZJSMvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZJSMvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:51:24 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:4799 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752492AbZJSMvX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:51:23 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R1453M98dN4015Lzz1202hzz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KRRIDE-03-5Y9-02
X-M-MSG: 
Date: Mon, 19 Oct 2009 14:52:12 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Li Hong <lihong.hi@gmail.com>
CC: Doug Thompson <dougthompson@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: fix a wrong goto clause in amd64_edac.c
Message-ID: <20091019125212.GA20983@aftab>
References: <20091019083329.GA7340@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091019083329.GA7340@uhli>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Oct 2009 12:51:13.0717 (UTC) FILETIME=[D7255E50:01CA50BA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 04:33:29PM +0800, Li Hong wrote:
> In amd64_edac_init(void) in amd64_edac.c, cache_k8_northbridges() is called
> before pci_register_driver. If it fails, should exit with err directly.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>

Thanks, queued for the next .32 update.

By the way, is this something you've caught by looking at the code
or is it a condition you're hitting on a real system with a specific
workload? If it is the second, I'd like to know more wrt to why
cache_k8_northbridges() is failing in your particular case.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

