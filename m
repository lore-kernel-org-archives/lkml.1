Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYFRVOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYFRVOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYFRVOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:14:21 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:46802 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605AbYFRVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:14:19 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Date: Wed, 18 Jun 2008 23:14:02 +0200
User-Agent: KMail/1.9.9
Cc: "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
References: <200806051100.12885.dex@dragonslave.de> <200806182157.04120.dex@dragonslave.de> <86802c440806181341w7c2ac2det817548c68d00040c@mail.gmail.com>
In-Reply-To: <86802c440806181341w7c2ac2det817548c68d00040c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806182314.03577.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1213823659;b5a1e9df;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jun 18, 2008 at 12:57 PM, Daniel Exner <dex@dragonslave.de> wrote:
> > Yinghai Lu wrote:
> >> On Sun, Jun 15, 2008 at 12:14 PM, Daniel Exner <dex@dragonslave.de> 
> >> > I guss you no longer need the complete dmesg output?
> >>
> >> still need that... wonder why your irq routing have same entris from
> >> your BIOS/ACPI?
> >
> > Again, sorry for the delay. I raised the Kernel buffer and added an
> > output, done using rc6.

> > Local APIC disabled by BIOS -- you can enable it with "lapic"
>
> sound interesting...
Tried that numerous times before. This gives me:

Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
mapped APIC to ffffb000 (fee00000)

But nothing else happens. I guess the chipset doesnt support IOAPIC so a local 
APIC doesnt give any benefit. (And thats the deeper cause of the regression I 
originaly reported)

--
Greetings
Daniel Exner
