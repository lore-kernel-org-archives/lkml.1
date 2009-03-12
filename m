Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZCLRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZCLRkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZCLRk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:40:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27997 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751700AbZCLRk0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:40:26 -0400
X-BigFish: VPS-24(za62sz1432R9370P98dR1805M936fKzz1202hzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KGEMET-02-5NL-01
Date: Thu, 12 Mar 2009 18:40:10 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: x86-microcode: get rid of set_cpus_allowed()
Message-ID: <20090312174010.GI20716@alberich.amd.com>
References: <1236627539.5168.48.camel@earth> <200903111714.37444.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200903111714.37444.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Mar 2009 17:40:12.0396 (UTC) FILETIME=[988312C0:01C9A339]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 07:44:37AM +0100, Rusty Russell wrote:
> On Tuesday 10 March 2009 06:08:59 Dmitry Adamushko wrote:
> > 
> > Hi,
> > 
> > 
> > here is a possible candidate for Rusty's cpumask-refactored series.
> > Note the [*] remark below though.
> 
> Ah, OK, I'll drop my version then (below) in favor of this, and will
> push to Ingo with the others if he doesn't take it directly.

Sorry guys -- for the late reply --
but I missed Dmitry's mail due to some silly mail filtering and had to
restore his mail ...

Now I've tested both patches and both seem to reliably prevent
microcode updates on CPU1 and CPU2 of an Phenom X3 after
suspend/resume. (Just CPU0 was updated.)

Then I've tested mainline kernel w/o your patches and I've observed
similar problems. I've seen that sometimes ucode of CPU0 was not
updated and sometimes CPU1 and CPU2 were not updated.

I'll look into this asap.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


