Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXHBMrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXHBMrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXHBMrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:47:45 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:45205 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbXHBMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:47:45 -0400
Date: Thu, 2 Aug 2007 13:47:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Message-ID: <20070802124729.GB30304@srcf.ucam.org>
References: <1186047747.18821.450.camel@queen.suse.de> <200708021145.09377.adrian@suse.de> <1186048701.18821.459.camel@queen.suse.de> <20070802120221.5474e732@the-village.bc.nu> <20070802111327.GA29002@srcf.ucam.org> <20070802125947.4a1ff933@the-village.bc.nu> <20070802115743.GB29735@srcf.ucam.org> <1186056386.18821.497.camel@queen.suse.de> <20070802121556.GA30114@srcf.ucam.org> <1186058118.18821.516.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186058118.18821.516.camel@queen.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22 regression: thermal trip points
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 02:35:18PM +0200, Thomas Renninger wrote:
> On Thu, 2007-08-02 at 13:15 +0100, Matthew Garrett wrote:
> > That machine has no active thermal trip points, so I'm not sure how it's 
> > relevant here.
> >From above: "Windows as I understand it has vendor mechanisms to..."
> Maybe thermal trip points are not influenced here, it's at least about
> thermal management and another prove that we cannot just try to copy
> Windows behavior, but need to provide workarounds wherever possible.

There's absolutely no evidence in the bug log there that the user's 
problems are in any way due to Windows-specific code. The SetSilentMode 
stuff is an additional item of functionality that underclocks various 
bits of hardware, not one that's actually required for the platform to 
function correctly.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
