Return-Path: <linux-kernel-owner+w=401wt.eu-S1764875AbXHDNm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764875AbXHDNm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbXHDNmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:42:16 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:43289 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758956AbXHDNmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:42:16 -0400
Date: Sat, 4 Aug 2007 14:42:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: William Pettersson <william.pettersson@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, vojtech@suse.cz
Message-ID: <20070804134206.GA3536@srcf.ucam.org>
References: <46B03A42.3030708@gmail.com> <46B46DFA.7000909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B46DFA.7000909@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: ALPS touchpad with new Dell not recognised
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 10:15:54PM +1000, William Pettersson wrote:
> Hi LKML,
> Thanks to Vojtech for some advice, I finally got something happening
> with this.  Turns out I had to add support for a new model in alps.c,
> the attached file does this successfully for my laptop.  It'd be nice to
> have others test it, but I am yet to find anyone else who has this same
> laptop, with the same mouse issues I have.
> 
> With this patch, I now get a functioning touchpad, including side
> scrolling, circle scrolling, corner taps etc.  However, I did have to
> ramp the configuration numbers up significantly from my old Thinkpad
> with its synaptics touchpad.  Minspeed is now 0.8 and maxspeed is 10. 
> Also the VertScrollDelta is 10.  I don't know whether these numbers are
> crazy high, or just normal for the Alps though.

ALPS pads have different resolution to Synaptics ones, so need different 
default configuration. If you use the git version of the Xorg Synaptics 
driver then it'll automatically configure itself based on information 
from the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
