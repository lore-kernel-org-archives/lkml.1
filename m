Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZD2NUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZD2NUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760790AbZD2NTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:19:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:33026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761300AbZD2NTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:19:31 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot even when ignore_ppc=0
Date: Wed, 29 Apr 2009 15:19:28 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
References: <20090415225348.GW8311@plum> <200904201113.31371.trenn@suse.de> <20090420104529.GB6670@elte.hu>
In-Reply-To: <20090420104529.GB6670@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904291519.29683.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009 12:45:29 Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > On Monday 20 April 2009 07:13:51 Len Brown wrote:
> > > FYI,
> > > Thanks to Ebay, I now have a T60:-)
> > Hmm, Lenovo sold a lot different machines as T60.
> > I found an acpidump of a T60 here without any _PPC function
> > at all.
> > 
> > > and so i put the DSDT here:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=13139
> > > 
> > > I'll poke at this in more detail soon...
> > Ingo, can you place yours somewhere too, please.
> > This one should be taken into account for _PPC code changes
> > as it seem to implement some corner case.
> 
> Sure, find it attached below.
> 
> 	Ingo
> 
> DSDT @ 0x7f6e65e7
>   0000: 44 53 44 54 65 c7 00 00 01 49 4c 45 4e 4f 56 4f  
...
Ingo, did you do a BIOS update in between?
The DSDT and SSDTs you added do not contain a _PPC function.
These ACPI tables definitely do not suffer from an initial _PPC
evaluation.

    Thomas
