Return-Path: <linux-kernel-owner+w=401wt.eu-S1946024AbXBCNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946024AbXBCNBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 08:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945989AbXBCNBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 08:01:18 -0500
Received: from smtp.x263.net ([211.150.96.22]:39723 "EHLO smtp2.263.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945995AbXBCNBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 08:01:18 -0500
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Feb 2007 08:01:17 EST
X-KSVirus-check: 0
X-ABS-CHECKED: 1
X-SENDER-IP: 221.201.75.142
X-LOGIN-NAME: linux
Subject: Re: Slower CPU frequency reported by the kernel
From: "Di, Wu" <linux@51sun.cn>
To: lnx.tmp@gmail.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <eq1ukv$p21$1@sea.gmane.org>
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	 <eq1ukv$p21$1@sea.gmane.org>
Content-Type: text/plain
Date: Sat, 03 Feb 2007 12:42:50 +0000
Message-Id: <1170506571.4546.4.camel@linux-soc5.51sun.cn>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

maybe, you start a powersaved service, and enable the cpufreq module of
kernel. You need run "powersave -f" for fix your CPU to highest
frequency supported.

On Sat, 2007-02-03 at 12:19 +0000, lnx.tmp@gmail.com wrote:
> On Fri, 02 Feb 2007 12:11:25 +0100, Francis Moreau wrote:
> > Hi,
> > 
> > I'm using a PC with AMD 64 3000+ cpu which is theoricaly running at
> > 2Ghz. But when looking at /proc/cpuinfo, the kernel reports that it
> > runs only at 1Ghz:
> > ...
> > What's going wrong ?
> 
> Do you have feature called "Cool N' Quiet" enabled in BIOS?
> I had the same problem and disabling the feature the problem resolved.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


