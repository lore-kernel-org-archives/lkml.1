Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZFCVE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZFCVE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZFCVEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:04:48 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:27752 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbZFCVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:04:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAB+CJkpR9Rle/2dsb2JhbADQfwiEAwU
Date: Wed, 3 Jun 2009 23:04:39 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Rui Santos <rsantos@grupopie.com>
Cc: Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andriy Gapon <avg@icyb.net.ua>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
Message-ID: <20090603210439.GO21360@infomag.iguana.be>
References: <20090430094918.GC4141@infomag.iguana.be> <4A254EBF.70004@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A254EBF.70004@grupopie.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

> Just to let you know that gbl_smi_en=0, also solves the problem with
> Intel DG35EC motherboard, witch uses a  82801HB I/O Controller Hub (ICH8)

Thanks for the feedback. I'm going to put the code in the iTCO_vendor_support code
so that the iTCO_wdt watchdog code stays clean. The glb_smi_en is and stays a dirty
hack... (and I will also document it as such). The real solution is to have the BIOS
code fixed...

Kind regards,
Wim.

