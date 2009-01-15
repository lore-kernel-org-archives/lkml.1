Return-Path: <linux-kernel-owner+w=401wt.eu-S933451AbZAOV5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbZAOV5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZAOV5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:57:01 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:40648 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZAOV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:57:00 -0500
Date: Thu, 15 Jan 2009 16:56:56 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: AE_ERROR, ACPI thermal trip point state changed
In-reply-to: <48ABDF1E.3010101@freemail.hu>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0901151655540.4737@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_n1VZ5EvLrde/b4NIiQKO6A)"
References: <47B328AA.1000800@freemail.hu> <47B3F147.7000704@freemail.hu>
 <47CF96E2.9020302@freemail.hu>
 <1204757373.10256.179.camel@acpi-hp-zz.sh.intel.com>
 <823A93EED437D048963A3697DB0E35DE0129BB78@pdsmsx414.ccr.corp.intel.com>
 <47D0E694.5050102@freemail.hu>
 <1204874686.10256.185.camel@acpi-hp-zz.sh.intel.com>
 <47D24341.5070908@freemail.hu>
 <1205113940.10256.191.camel@acpi-hp-zz.sh.intel.com>
 <48ABDF1E.3010101@freemail.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_n1VZ5EvLrde/b4NIiQKO6A)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Wed, 20 Aug 2008, Németh Márton wrote:

> Zhang, Rui wrote:
> > On Sat, 2008-03-08 at 15:41 +0800, Németh Márton wrote:
> >> Zhang, Rui wrote:
> >>> On Fri, 2008-03-07 at 14:54 +0800, Németh Márton wrote:
> >>>> Hi,
> >>>>
> >>>> I downloaded pmtools from
> >>>>
> >> http://www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools-20071116.tar.bz2 and
> >>>> compiled: it created exactly the same result what my currently
> >>>> installed acpidump Debian
> >>>> package version 20071116-1. I think it is useless to send the same
> >> log
> >>>> again.
> >>>>
> >>>> After I boot the "Please send acpidump to
> >> linux-acpi@vger.kernel.org"
> >>>> message is already
> >>>> there. So when I first get the prompt I checked for this message in
> >>>> dmesg and executed
> >>>> the given command. Here is my result:
> >>>>
> >>>> # cat /proc/acpi/thermal_zone/*/*
> >>>> 0 - Active; 1 - Passive
> >>>> <polling disabled>
> >>>> state:                   ok
> >>>> temperature:             42 C
> >>>> critical (S5):           155 C
> >>>> passive:                 84 C: tc1=2 tc2=5 tsp=0 devices=CPU0
> >>>> active[0]:               70 C: devices=
> >>>> # ls /proc/acpi/thermal_zone/*/*
> >>>> /proc/acpi/thermal_zone/THRM/cooling_mode
> >>>> /proc/acpi/thermal_zone/THRM/polling_frequency
> >>>> /proc/acpi/thermal_zone/THRM/state
> >>>> /proc/acpi/thermal_zone/THRM/temperature
> >>>> /proc/acpi/thermal_zone/THRM/trip_points
> >>>>
> >>>> Maybe this is related to
> >>>> http://bugzilla.kernel.org/show_bug.cgi?id=8544 ?
> >>>>
> >>> Hi, Németh,
> >>>
> >>> Please ignore the debug patch I sent and try this one.
> >> I created both the dmesg logs:
> >>
> >> 1. Clevo-D410J-patch-debug-thermal2.txt: the patch-debug-thermal was
> >> only
> >> applied, (and added a missing "\n").
> >>
> >> 2. Clevo-D410J-thermal-fix.txt: the thermal-fix patch was also
> >> applied.
> >> In this case the AE_ERROR message is not there any more on Clevo D410J
> >> laptop.
> >>
> > Thanks for your help in debugging this.
> > We will get the "thermal-fix" patch upstream soon.
> 
> As of 2.6.27-rc3 the patch is still not included in the mainstream. I
> hope that this patch was not forgotten completely.
> 
> 	Márton Németh

Apparently it was dropped.

should have put the patch here:
http://bugzilla.kernel.org/show_bug.cgi?id=8544

I'll do it now.

thanks,
-Len

--Boundary_(ID_n1VZ5EvLrde/b4NIiQKO6A)--
