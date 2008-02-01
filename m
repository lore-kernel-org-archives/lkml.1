Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYBAVSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYBAVSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYBAVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:18:04 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:60245 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbYBAVSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:18:02 -0500
Date: Fri, 1 Feb 2008 22:17:34 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: 2.6.24-git9 ACPI oops - regression
Message-ID: <20080201211734.GD4199@ics.muni.cz>
References: <20080201132551.GA4199@ics.muni.cz> <200802011529.20167.rjw@sisk.pl> <200802011207.03211.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802011207.03211.lenb@kernel.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 01 Feb 2008 22:17:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 12:07:03PM -0500, Len Brown wrote:
> this worked in 2.6.24?

At least in 2.6.24-rc8 seemed to be OK, for the first time, I encountered the
bug in 2.6.24-git4. 2.6.24-git6 seemed to be OK. 2.6.24-git9 is not. 

> You are running the "dock" driver in both cases?

I use thinkpad acpi module, ACPI_DOCK is always built in.

> Is this reproducible?

In 2.6.24-git4, it was 100% reproducible - just pressing undock button on the
dock and the oops has been generated.

In 2.6.24-git9, I do not know, whether it is reproducible or not. And as I'm
ill and my dock is in work, I'm not sure when I be ready to test it again.

> If yes, please open a bugzilla entry here:
> 
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> Component = Config-hotplug
> 
> and attach the output from acpidump

do you need just acpidump as is or should I do acpidump when docked?

-- 
Luká¹ Hejtmánek
