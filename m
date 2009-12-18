Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZLRSpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZLRSpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZLRSpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:45:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZLRSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:45:00 -0500
Date: Fri, 18 Dec 2009 19:44:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3/5 -v2] acpi, apei, HEST table parsing
Message-ID: <20091218184443.GD1470@ucw.cz>
References: <1260429419.15264.395.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260429419.15264.395.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-12-10 15:16:59, Huang Ying wrote:
> HEST describes error sources in detail; communicating operational
> parameters (i.e. severity levels, masking bits, and threshold values)
> to OS as necessary. It also allows the platform to report error
> sources for which OS would typically not implement support (for
> example, chipset-specific error registers).
> 
> HEST information may be needed by other subsystems. For example, HEST
> PCIE AER error source information describes whether a PCIE root port
> works in "firmware first" mode, this is needed by general PCIE AER
> error subsystem. So a public HEST tabling parsing interface is
> provided.

Perhaps you can remove unused hest_exit()?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
