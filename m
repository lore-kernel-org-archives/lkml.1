Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbXFDJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbXFDJX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXFDJXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:23:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:50366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbXFDJXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:23:40 -0400
Date: Mon, 4 Jun 2007 11:13:31 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       trenn@suse.de, Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070604091331.GB4802@suse.de>
References: <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org> <20070522090636.GO10714@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070522090636.GO10714@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha4, Kernel 2.6.21-10-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:06:36AM +0200, Pavel Machek wrote:
 
> We need to ignore trip point updates from BIOS, and we need to poll
> thermals when use overrides trip points. That's expected. Plus I've
> yet to see platform actually updating the trip points.

Thinkpad 600, whenever a trip point is crossed, all trip points are updated.
I think they implemented hysteresis that way.
ISTR that hp nx5000 did something similar, but i might be wrong on this one.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
