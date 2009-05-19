Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbZESHWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbZESHWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZESHWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:22:34 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:42400 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752265AbZESHWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:22:33 -0400
Message-ID: <783496.86803.qm@web32608.mail.mud.yahoo.com>
X-YMail-OSG: uHnyYesVM1lk3QClaSMy9ZOXH4OTatAPo6zN8pMdYt3Z5U1JWmVwHaXZtzck.mbt9fjdk_OmLpeHRx24eyblzyrZicApZF1334Ar8I5dVRAaI9QWrOngFnM2DRHteDA4SKzmckDL881Cixp7q2znB1pKszypNKW4M1i2aqT5_UM6_.lqVm9FWinrSvrKSNin5US_ksUmyc5nleHLveJ4G5hG9xgnNGsxpCbuvwJojZ2uWrqirHvbClARpRlUqobX4hRDcmEV.5kjCPDBFwuHPVZTJ2r1cON9h9_5H69gcXF8Y2bWcg--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.scG.LA0DKB@chimera>  <424718.52835.qm@web32607.mail.mud.yahoo.com> <ac3eb2510905181726q3b996b8ei9c6a74fe1d3bb17d@mail.gmail.com>
Date: Tue, 19 May 2009 00:22:33 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13178] Booting very slow
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <ac3eb2510905181726q3b996b8ei9c6a74fe1d3bb17d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Kay Sievers <kay.sievers@vrfy.org>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Kernel Testers List <kernel-testers@vger.kernel.org>
> Sent: Tuesday, May 19, 2009 2:26:04 AM
> Subject: Re: [Bug #13178] Booting very slow
> 
> On Mon, May 18, 2009 at 10:15, Martin Knoblauch wrote:
> 
> >> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> >> Subject        : Booting very slow
> >> Submitter    : Martin Knoblauch
> >> Date        : 2009-04-24 12:45 (23 days old)
> >> References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4
> >
> >  The issue is still open. It turns out that starting with 2.6.29-rc1 
> /proc/mounts already has a "sysfs" line when entering the startup scripts from 
> initrd. This breaks the RHEL4 firmware hotplug script.
> 
> Is that possibly a missing/failing "umount /sys" _in_ initramfs, which
> leaves the sysfs entry in /proc/mounts behind, which then shows up as
> a duplicate when running in the real rootfs?
> 

 could be. Remains the question, why it never showed up before 2.6.29. I compared my initrd images for 2.6.28 and 2.6.29-rc1, and they only differ in the module-binaries.

Cheers
Martin

