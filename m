Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXIAVpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXIAVpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbXIAVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:45:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:43280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbXIAVpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:45:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 1/1] i386: fix a hang on stuck nmi watchdog
Date: Sat, 1 Sep 2007 23:45:00 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, eranian@hpl.hp.com, B.Steinbrink@gmx.de,
       linux-kernel@vger.kernel.org
References: <20070901205417.305538884@mvista.com>
In-Reply-To: <20070901205417.305538884@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709012345.00991.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 September 2007 22:54:17 Daniel Walker wrote:
> In the case when an nmi gets stucks the endflag stays equal to zero. This
> causes the busy looping on other cpus to continue, even tho the nmi test
> is done.
> 
> On my machine with out the change below the system would hang right after
> check_nmi_watchdog(). The change below just sets endflag prior to checking
> if the test was successful or not.
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

Added thanks. I guess it's .23 material.

-Andi

