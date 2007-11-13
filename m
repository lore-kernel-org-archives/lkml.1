Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXKMX3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXKMX3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbXKMX3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:29:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:37158 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754064AbXKMX3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:29:03 -0500
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX18WFcY8S3EWxYgWmAigB9AuLFDDyrFtChhdimVmuI
	N/7hYNaOtu5OIP
Date: Wed, 14 Nov 2007 00:28:59 +0100
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Message-ID: <20071113232859.GA4681@section-eight>
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113212230.77cadecd@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan!

On Tue, Nov 13, 2007 at 09:22:30PM +0000, Alan Cox wrote:
> It isn't a known issue, and it suprises me as SG_IO basically passes
> commands through to the drive. We don't support speed change via xfermode
> setting but GPCMD_SET_STREAMING sohuld behave.
> 
> Do you have a simple code example that shows the problem ?

http://svn.mplayerhq.hu/mplayer/trunk/stream/stream_dvd.c?view=markup

See dvd_set_speed(). The drive I'm using is an Optiarc DVD RW AD-7170A.
With the "old" ATA driver dvd_set_speed() works, with libata it doesn't.

Regards
Sebastian
