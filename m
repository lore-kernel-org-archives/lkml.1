Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbXKNMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbXKNMLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXKNMLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:11:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:54217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752949AbXKNMLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:11:33 -0500
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX18ueGwxrjAuDCPwjuLKJL/yIsNEv6Mghp/0rFgNr4
	QLUx0sRj35Nh9N
Date: Wed, 14 Nov 2007 13:11:33 +0100
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Message-ID: <20071114121133.GA5253@section-eight>
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113232859.GA4681@section-eight>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:28:59AM +0100, Sebastian Kemper wrote:
> http://svn.mplayerhq.hu/mplayer/trunk/stream/stream_dvd.c?view=markup
> 
> See dvd_set_speed(). The drive I'm using is an Optiarc DVD RW AD-7170A.
> With the "old" ATA driver dvd_set_speed() works, with libata it doesn't.

Hello Alan,

in the meantime I tried the kernels 2.6.23.1 as well as 2.6.24-rc2. Both
show the same behaviour when using libata with AMD/NVIDIA PATA support:
GPCMD_SET_STREAMING via SG_IO doesn't have any effect. With these two
kernels I didn't try the "old" ATA driver - but I assume it would've
worked out (changing your system from ATA to libata and vice versa
turned out to be quite time consuming ;)).

Regards
Sebastian
