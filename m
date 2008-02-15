Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbYBOMxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbYBOMxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYBOMxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:53:25 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36767 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbYBOMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:53:24 -0500
Date: Fri, 15 Feb 2008 13:53:19 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.25-rc1 regression - IBM ACPI backlight
Message-ID: <20080215125318.GC4269@ics.muni.cz>
References: <20080214103801.GB4366@ics.muni.cz> <20080214122452.GB12775@khazad-dum.debian.net> <20080215110213.GA5648@ics.muni.cz> <20080215120720.GA31578@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080215120720.GA31578@srcf.ucam.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 15 Feb 2008 13:53:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:07:20PM +0000, Matthew Garrett wrote:
> On Fri, Feb 15, 2008 at 12:02:13PM +0100, Lukas Hejtmanek wrote:
> > 2.6.24 kernel has two acpi_video[01]. 2.6.25-rc1 does not, it contains only
> > acpi_video0 (even in text mode in single user without X being loaded) which
> > does not work at all.
> 
> Sigh. Ok. Could you attach the output of acpidump and lspci, please? 
> I'll try to figure out why this is wrong.

I created a bug report here including acpidump and lspci:
http://bugzilla.kernel.org/show_bug.cgi?id=9995

-- 
Luká¹ Hejtmánek
