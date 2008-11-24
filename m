Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKXBWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKXBWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 20:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKXBWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 20:22:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYKXBWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 20:22:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: Regression: ACPI AC driver doesn't work on Toshiba Portege R500 (bisected)
Date: Mon, 24 Nov 2008 02:21:54 +0100
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "Zhang, Rui" <rui.zhang@intel.com>, walken <walken@zoy.org>
References: <200811230053.14211.rjw@sisk.pl> <200811240037.15835.rjw@sisk.pl> <1227489340.3991.54.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1227489340.3991.54.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811240221.54716.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of November 2008, Zhao Yakui wrote:
> On Mon, 2008-11-24 at 07:37 +0800, Rafael J. Wysocki wrote:
> > On Sunday, 23 of November 2008, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > With current mainline (2.6.28-rc6-git1 as of today) on Toshiba Portege R500 the
> > > status of the AC adapter is not updated when the adapter is unplugged and
> > > plugged in.  Evidently, /sys/class/power_supply/ADP1/online always contains the
> > > same value.  Interestingly enough, though, if the box is suspended to RAM and
> > > resumed, the status of the AC adapter is correctly updated, but the value read
> > > at that time remains in /sys/class/power_supply/ADP1/online until the next
> > > suspend/resume cycle regardless of what's going on with the AC adapter.
> > > 
> > > 2.6.27.7 works correctly on this box so the recent EC patches don't seem to
> > > cause this regression to happen.
> > > 
> > > Any other ideas?
> Hi, Rafael
>     Will you please open a new bug at
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI and attach the
> output of acpidump, dmesg, lspci -vxxx?
>     If no ACPI event is reported when AC adapter is unplugged and
> plugged, the /sys/class interface can't display the correct AC status.
> Now Rui is working on this issue and the patch is already finished. But
> it is not sent to Lenb.

Can you give me a link to the patch, please?
 
>     From the problem description it seems that the problem is related
> with the AC driver. But from the git-bisect it seems that the problem is
> related with the button driver(Fix power button device). 
> 
>     Any-way, please attach the output of dmesg, acpidump, lspci -vxxx.

Created http://bugzilla.kernel.org/show_bug.cgi?id=12091 with the information
attached as requested.

Thanks,
Rafael
