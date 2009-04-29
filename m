Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZD2WAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZD2WAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZD2WAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:00:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52645 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZD2WAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:00:42 -0400
Date: Wed, 29 Apr 2009 23:00:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090429220037.GA8604@srcf.ucam.org>
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum> <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum> <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org> <20090429213930.GE6968@plum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429213930.GE6968@plum>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 02:39:31PM -0700, Darrick J. Wong wrote:

> I don't know about XP's copy of intelppm.sys, but this would seem to confirm
> that WS03 and WS08 check _PPC at boot time.

Ok, so that makes things interesting. From what we know about the T60 
(and based on Ingo's report), _PPC may evaluate to 2 on bootup. However, 
if this is ignored then later notifications are correct. This implies 
that Windows either ignores the initial evaluation or does something 
that triggers a notification.

The only notifications appear to be sent from event methods, so there's 
nothing obvious there that we can trigger. I'm actually quite confused 
by this now. Ingo, if you re-add that block, does your system stop 
working again?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
