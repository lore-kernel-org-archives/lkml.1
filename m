Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbYKYJHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbYKYJHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYKYJHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:07:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYKYJHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:07:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: Regression: ACPI AC driver doesn't work on Toshiba Portege R500 (bisected)
Date: Tue, 25 Nov 2008 10:06:49 +0100
User-Agent: KMail/1.9.9
Cc: "Zhao, Yakui" <yakui.zhao@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       walken <walken@zoy.org>
References: <200811230053.14211.rjw@sisk.pl> <200811241430.02434.rjw@sisk.pl> <1227576051.15014.305.camel@rzhang-dt>
In-Reply-To: <1227576051.15014.305.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811251006.50223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of November 2008, Zhang Rui wrote:
> On Mon, 2008-11-24 at 21:30 +0800, Rafael J. Wysocki wrote:
> > On Monday, 24 of November 2008, Zhang Rui wrote:
[--snip--]
> > 
> > Do I understand correctly that you intend to revert commit
> > faee816b1502385dc9bc5abf2960d1cc645844d1 and provide an alternative patch
> > for walken?
> > 
> First, I think it's safe to revert
> commit ﻿faee816b1502385dc9bc5abf2960d1cc645844d1
> because bug #10503 can not be reproduced in the upstream kernel as a
> result of another commit  49db139955d3392c6c4facf987905d0a9afed581

OK, I'll send the revert of faee816b1502385dc9bc5abf2960d1cc645844d1 to Len
later today.

> Second, if we can make sure all the pci devices won't issue any PMEs
> when the /sys/devices/.../power/wakeup files are "disabled",

It is supposed to work like this.  If it doesn't, then there is a bug that has
to be fixed.

> then I'd glad to generate another patch which always enables the PCI root
> bridge (PNP0A03) GPE, both at runtime and sleep state, just like what we do
> for the buttons.

Please go for it.

Thanks,
Rafael
