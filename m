Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZBBRFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZBBRFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZBBRFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:05:35 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:3399 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZBBRFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:05:34 -0500
X-BigFish: VPS-26(zz1432R98dR1805M936fMzzzzz32i6bh6di43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KEG7GO-02-A55-01
Date: Mon, 2 Feb 2009 18:05:06 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Mark Hounschell <markh@compro.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090202170506.GA19608@aftab>
References: <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <498416CE.4040101@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <498416CE.4040101@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 02 Feb 2009 17:05:08.0524 (UTC) FILETIME=[66CF2EC0:01C98558]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 04:15:58AM -0500, Mark Hounschell wrote:

[..]

> 
> So were you able to reproduce this with my .config. Has anyone booted a Hz=1000
> kernel on an AMD Phenom-II? Is there something wrong with my .config? Is there
> anything else I can do?

Hi,

sorry for the delay - I've been busy last week and couldn't get to your
problem. So, I couldn't reproduce the bug here with a Phenom II and your
kernel config. However, we have a working theory, so can you please send
me the output of

xxd /sys/firmware/acpi/tables/APIC

Also, can you boot a 64-bit, HZ1000 kernel on your machine?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

