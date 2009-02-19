Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZBSOMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZBSOMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZBSOMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:12:22 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55926 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752790AbZBSOMV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:12:21 -0500
X-BigFish: VPS-2(zz103dKzzzzz32i6bh)
X-WSS-ID: 0KFBGRS-01-4YS-01
Date: Thu, 19 Feb 2009 15:11:31 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090219141131.GM4301@alberich.amd.com>
References: <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com> <20090209141841.GA31643@aftab> <49904BED.7090208@cfl.rr.com> <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <499D364C.3010704@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Feb 2009 14:11:51.0032 (UTC) FILETIME=[02718F80:01C9929C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Can you please provide us output of lspci -vvxxx.
(Please run this as root.)

Furthermore you can try booting your 1000HZ kernel
with following kernel command lines:

(1) acpi_skip_timer_override apic=debug
(2) nohpet apic=debug
(3) acpi_skip_timer_override nohpet apic=debug

and send us all dmesg output.


Thanks!

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


