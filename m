Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZCIKbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZCIKbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCIKbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:31:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:57682 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZCIKbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:31:11 -0400
X-BigFish: VPS-38(zz1432R98dR1805M936fK9371P1b0bMzzzz5a6ci2db9iz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG8IJF-01-PQR-01
Date: Mon, 9 Mar 2009 11:30:42 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jike Song <albcamus@gmail.com>
CC: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309103042.GA20716@alberich.amd.com>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com> <df9815e70903090300v1f5077a9r18a9d343ae4f8687@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <df9815e70903090300v1f5077a9r18a9d343ae4f8687@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Mar 2009 10:30:52.0898 (UTC) FILETIME=[1F6A5C20:01C9A0A2]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 06:00:35PM +0800, Jike Song wrote:
> On Mon, Mar 9, 2009 at 5:43 PM, Dragoslav Zaric
> <dragoslav.zaric.kd@gmail.com> wrote:
> > Hello,
> >
> > I was browsing Intel web site for my processor docs and I bumped
> > on download link "Linux* Processor Microcode Data File" and it says
> > there:
> >
> > "The microcode data file contains the latest microcode definitions for
> > all Intel processors.
> > Intel releases microcode updates to correct processor behavior as
> > documented in the respective
> > processor specification updates. While the regular approach to getting
> > this microcode update is via
> > a BIOS upgrade, Intel realizes that this can be an administrative
> > hassle. The Linux Operating System
> > and VMware ESX products have a mechanism to update the microcode after
> > booting. For example,
> > this file will be used by the operating system mechanism if the file
> > is placed in the /etc/firmware
> > directory of the Linux system."
> >
> > So, does new kernel versions just copy this microcode update file in
> > /etc/firmware folder or new
> > instructions are replaced in assembly code ?
> >
> 
> Linux provides an microcode driver for Intel & AMD CPUs:
> 
>     arch/x86/kernel/microcode_*
> 
> and there is a service called "microcode_ctl" to open it and write the
> microcode on every starting.   Where to find the microcode data is
> this service specified, and the kernel doesn't care it.  You may want
> to find:

> http://www.urbanmyth.org/microcode/

FYI, microcode patch loading for AMD CPUs uses only the firmware
loader interface. The patches for AMD CPUs are available from

http://www.amd64.org/support/microcode.html


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


