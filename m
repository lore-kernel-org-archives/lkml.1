Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZDTJNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZDTJNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZDTJNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:13:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:52433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZDTJNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:13:33 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot even when ignore_ppc=0
Date: Mon, 20 Apr 2009 11:13:29 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <20090415225348.GW8311@plum> <20090416224507.GA31984@srcf.ucam.org> <alpine.LFD.2.00.0904200112290.10996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904200112290.10996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904201113.31371.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009 07:13:51 Len Brown wrote:
> FYI,
> Thanks to Ebay, I now have a T60:-)
Hmm, Lenovo sold a lot different machines as T60.
I found an acpidump of a T60 here without any _PPC function
at all.

> and so i put the DSDT here:
> http://bugzilla.kernel.org/show_bug.cgi?id=13139
> 
> I'll poke at this in more detail soon...
Ingo, can you place yours somewhere too, please.
This one should be taken into account for _PPC code changes
as it seem to implement some corner case.

Thanks,

      Thomas
