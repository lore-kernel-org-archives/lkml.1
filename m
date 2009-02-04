Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZBDPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZBDPt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZBDPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:49:16 -0500
Received: from ns.suse.de ([195.135.220.2]:60476 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZBDPtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:49:15 -0500
Message-ID: <4989B8EA.5000105@suse.de>
Date: Wed, 04 Feb 2009 16:48:58 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, len.brown@intel.com,
       shaohuhua.li@intel.com, kristen.c.accardi@intel.com, frank@f-seidel.de
Subject: Re: [PATCH] ACPI: add missing KERN_* constants to printks
References: <4989A784.3030604@suse.de> <200902041628.03675.elendil@planet.nl> <alpine.LRH.2.00.0902041642450.7690@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0902041642450.7690@vixen.sonytel.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Actually they should, but the right prefix :-)
> 
> Quoting include/linux/kernel.h:
> ...

Ah, no i see. And i missed the line (from janitors todo) that
this should only be done for line beginnings (and now KERN_CONT
for core/arch..).
Thank you very much that pointer. Will keep it in mind for my
further cleanups of this topic.
Of course i will then also redo the above patch.

Thanks,
Frank

