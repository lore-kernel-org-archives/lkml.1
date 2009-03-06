Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZCFKPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZCFKPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZCFKPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:15:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37350 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZCFKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:15:39 -0500
Date: Fri, 6 Mar 2009 10:15:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090306101533.GA6408@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org> <1236330536.12838.2.camel@hughsie-work.lan> <1236332843.19146.4.camel@petitemort> <20090306095623.GA6014@srcf.ucam.org> <1236333861.19146.9.camel@petitemort> <20090306100951.GA6268@srcf.ucam.org> <1236334376.19146.11.camel@petitemort>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236334376.19146.11.camel@petitemort>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 10:12:56AM +0000, Daniel Silverstone wrote:

> I see. One other thing occurred to me. Is there any way for Hal to know
> that the notify stuff is in place and thus doesn't need to
> poll /proc/acpi/toshiba/keys? Otherwise it's going to poll it anyway
> which fails to remove the periodic wakeups.

No. Distributions should build without --enable-toshiba if they ship a 
kernel with this functionaliy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
