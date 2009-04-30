Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZD3Kow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZD3Kow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZD3Kom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:44:42 -0400
Received: from citadel.icyb.net.ua ([212.40.38.140]:3829 "EHLO
	citadel.icyb.net.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZD3Kom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:44:42 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 06:44:40 EDT
Message-ID: <49F97E81.8020201@icyb.net.ua>
Date: Thu, 30 Apr 2009 13:33:37 +0300
From: Andriy Gapon <avg@icyb.net.ua>
User-Agent: Thunderbird 2.0.0.21 (X11/20090406)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
References: <20090430094918.GC4141@infomag.iguana.be>
In-Reply-To: <20090430094918.GC4141@infomag.iguana.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 30/04/2009 12:49 Wim Van Sebroeck said the following:
> Hi All,
> 
> I'm looking for people that can test the below patch(es).
> I'm mainly interested in knowing if you experience any side-effects when using this patch.
> (See also bugzilla 9868, 10195, 12363 & 12162).
> 
> For people not using the watchdog or without any reboot problems the driver should
> work as normal after compilation/installation/...
> 
> For people that have the ICH9 reboot problems: load the module with module-parameter
> gbl_smi_en=0 and test the watchdog functionality again.

BTW: when I suggested a similar patch for FreeBSD ichwd driver I was advised to
prominently warn that globally disabling SMI could possibly lead to dramatic
problems, especially on laptops. I.e. various ACPI things where SMI is used for
communication between OS and firmware. I am not sure if this issue is applicable
to laptops at all, but just in case.

-- 
Andriy Gapon
